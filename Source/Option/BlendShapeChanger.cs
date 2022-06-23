using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.SceneManagement;
using VRM;

namespace VMCAvatarMaterialChange
{
    class BlendShapeChanger : MonoBehaviour
    {
        private List<String> _commandList = new List<string>();
        private NalulunaAvatarsEvents _events;
        private double _songTime;
        private int _nowPoint;
        private Dictionary<String, BlendShapeControler> _controler = new Dictionary<string, BlendShapeControler>();
        private VRMBlendShapeProxy _proxy;

        public BlendShapeChanger()
        {
            _commandList.Add("StopAutoBlendShape");      //BlendShapeの受信による変更を停止
            _commandList.Add("StartLipSync");            //リップシンク受信開始
            _commandList.Add("StopLipSync");             //リップシンク受信停止
            _commandList.Add("SetBlendShapeSing");       //歌用の口の形(NalulunaAvatar専用)
            _commandList.Add("BlendShape");              //設定表情
            _commandList.Add("SetBlendShapeNeutral");    //標準表情変更
            _commandList.Add("StopSing");                //歌停止(NalulunaAvatar専用)
            _commandList.Add("StartSing");               //歌開始(NalulunaAvatar専用)

            _proxy = this.GetComponent<VRMBlendShapeProxy>();
            foreach (var clip in _proxy.BlendShapeAvatar.Clips)
            {
                //_controler[clip.Key.Name] = new BlendShapeControler(clip.Key);
                _controler[clip.Key.Name.ToUpper()] = new BlendShapeControler(clip.Key);
            }

        }
        private void Awake()
        {
            SceneManager.activeSceneChanged += OnActiveSceneChanged;
        }

        /// <summary>
        /// Called when the script is being destroyed.
        /// </summary>
        private void OnDestroy()
        {
            SceneManager.activeSceneChanged -= OnActiveSceneChanged;
            _commandList.Clear();
            _controler.Clear();
            _events = null;
            _commandList = null;
            _controler = null;
        }

        public void OnActiveSceneChanged(Scene prevScene, Scene nextScene)
        {
            if (nextScene.name == "MainMenu")
            {
                //MarionetteOscOnBlendShapProxyValueHarmony.StopAutoBlendShape = false;
                //MarionetteOscOnBlendShapProxyValueHarmony.StopAutoBlink = false;
                //MarionetteOscOnBlendShapProxyValueHarmony.StopLipSync = false;
                MarionetteOscOnBlendShapProxyApplyHarmony.StopAutoBlendShape = false;
                MarionetteOscOnBlendShapProxyApplyHarmony.StopAutoBlink = false;
                MarionetteOscOnBlendShapProxyApplyHarmony.StopLipSync = false;
                _events = null;
                _songTime = 0;
                _nowPoint = 0;
            }
            if (nextScene.name == "GameCore")
            {
                retryCnt = 0;
                SharedCoroutineStarter.instance.StartCoroutine(LoadJson());
            }
        }

        private int retryCnt;
        private IEnumerator LoadJson()
        {

            WaitLoad();

            if (string.IsNullOrEmpty(CustomPreviewBeatmapLevelHarmony.customLevelPath))
                if (retryCnt < 3)
                {
                    retryCnt++;
                    LoadJson();
                    yield break;
                }


            Logger.log?.Warn($"NalulunaAvatarsEvents Json Load Path:{CustomPreviewBeatmapLevelHarmony.customLevelPath}");

            string configuration = File.ReadAllText(CustomPreviewBeatmapLevelHarmony.customLevelPath);
            _events = JsonConvert.DeserializeObject<NalulunaAvatarsEvents>(configuration);
        }

        private IEnumerator WaitLoad()
        {
            yield return new WaitForSeconds(0.1f);
        }


        private void Update()
        {
            if (_events != null)
            {
                //イベントに合わせてステータスセット
                NextEvent();
                //BlendShapeセット
                UpdateBlendShape();
                _songTime += Time.unscaledDeltaTime;

            }

        }

        private void UpdateBlendShape()
        {
            if (_proxy == null) return;
            if (_proxy.gameObject.activeSelf == false) return;

            //BlendShape転送
            foreach (var clip in _proxy.BlendShapeAvatar.Clips)
            {
                if(_controler[clip.Key.Name.ToUpper()].isEnd == false)
                    _proxy.ImmediatelySetValue(clip.Key, _controler[clip.Key.Name.ToUpper()].Value);
            }
            _proxy.Apply();
        }

        private void NextEvent()
        {
            if (_nowPoint < _events._events.Count)
            {
                bool isRecursion = false;
                if (_events._events[_nowPoint]._time <= _songTime)
                {
                    //イベント割当
                    if (_events._events[_nowPoint]._key == "BlendShape")
                    {
                        var setData = _events._events[_nowPoint]._value.Split(',');
                        if (_controler.ContainsKey(setData[0].ToUpper()))
                        {
                            _controler[setData[0].ToUpper()].Set(_events._events[_nowPoint]._duration, setData.Length >= 2 ? float.Parse(setData[1]):1f);
                        }
                    }

                    if (_events._events[_nowPoint]._key == "StopAutoBlendShape")
                    {
                        //MarionetteOscOnBlendShapProxyValueHarmony.StopAutoBlendShape = true;
                        MarionetteOscOnBlendShapProxyApplyHarmony.StopAutoBlendShape = true;
                    }

                    if (_events._events[_nowPoint]._key == "StartAutoBlink")
                    {
                        //MarionetteOscOnBlendShapProxyValueHarmony.StopAutoBlink = false;
                        MarionetteOscOnBlendShapProxyApplyHarmony.StopAutoBlink = false;
                    }
                    if (_events._events[_nowPoint]._key == "StopAutoBlink")
                    {
                        //MarionetteOscOnBlendShapProxyValueHarmony.StopAutoBlink = true;
                        MarionetteOscOnBlendShapProxyApplyHarmony.StopAutoBlink = true;
                    }

                    if (_events._events[_nowPoint]._key == "StartLipSync")
                    {
                        //MarionetteOscOnBlendShapProxyValueHarmony.StopLipSync = false;
                        MarionetteOscOnBlendShapProxyApplyHarmony.StopLipSync = false;
                    }
                    if (_events._events[_nowPoint]._key == "StopLipSync")
                    {
                        //MarionetteOscOnBlendShapProxyValueHarmony.StopLipSync = true;
                        MarionetteOscOnBlendShapProxyApplyHarmony.StopLipSync = true;
                    }


                    //再帰処理ON
                    isRecursion = true;
                    _nowPoint++;
                }

                //再帰処理で時間内の処理を実行する
                if (isRecursion) NextEvent();
            }
        }

        private class BlendShapeControler
        {
            public float Value { get => GetValue(); }
            private BlendShapeKey _key;
            private float _duration;
            private float _value;
            private float _setvalue;
            private float _time;
            public bool isEnd { get; private set; }
            private bool isExit = false;

            public BlendShapeControler(BlendShapeKey key)
            {
                _key = key;
                isEnd = true;
                isExit = false;
            }

            public void Set( float duration,  float value)
            {
                _duration = duration;
                _value = value;
                isEnd = false;
                isExit = false;
                _time = 0f;
            }
            private float GetValue()
            {
                if (isEnd) return 0;

                if (_time < _duration)
                {
                    if (isExit)
                        _setvalue -= _value * (Time.deltaTime / 0.3f);
                    else
                        _setvalue += _value * (Time.deltaTime / 0.3f);

                    _setvalue = Mathf.Clamp(_setvalue, 0, _value);

                    _time += Time.unscaledDeltaTime;
                }
                else if (isExit)
                {
                    _setvalue = 0;
                    isEnd = true;
                }
                else if(isExit == false)
                {
                    _time = 0;
                    //_value = 0;
                    _duration = 0.1f;
                    isExit = true;
                }
                

                Logger.log?.Warn($"GetValue AppendData:{ _value * (Time.deltaTime / 0.1f)} _setvalue:{_setvalue} value:{_value} time:{_time}");

                return _setvalue;
            }
        }


    }

    public class NalulunaAvatarsEvents
    {
        public string _version { get; set; }
        public List<Events> _events { get; set; } = new List<Events>();
    }
    public class Events
    {
        public float _time { get; set; }
        public float _duration { get; set; }
        public string _key { get; set; }
        public string? _value { get; set; }
    }
}
