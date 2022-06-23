using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UniGLTF;
using UnityEngine;
using UnityEngine.Animations;
using VRM;

namespace VMCAvatarMaterialChange
{
    public class ChangeAvatar : MonoBehaviour
    {
        //public static ChangeAvatar instance = new ChangeAvatar();

        private RuntimeGltfInstance BaseAvatar;
        private RuntimeGltfInstance ConstraintAvatar;
        private List<RuntimeGltfInstance> Avatars = new List<RuntimeGltfInstance>();
        private VRMBlendShapeProxy BaseProxy;
        private VRMBlendShapeProxy ConstraintProxy;

        private int AvtiveAvatarNo;

        public void SetAvatar(RuntimeGltfInstance avatar)
        {
            if (avatar is null) return;
            //GameObject setAvataraObj = avatar.transform.root.gameObject;
            avatar.Root.name = $"ChangeAvatar{Avatars.Count + 1}";
            Avatars.Add(avatar);


            ////デバッグ用
            //foreach (var skinnedMeshRenderer in avatar.Root.GetComponentsInChildren<Renderer>(true))
            //{
            //    if (skinnedMeshRenderer.gameObject.layer != 10)
            //    {
            //        skinnedMeshRenderer.gameObject.layer = 10;
            //    }
            //}

            //Avatars.Add(GameObject.Instantiate(avatar, new Vector3(0f, 0f, 0f), Quaternion.identity, setAvataraObj.GetComponent<Transform>()) as GameObject);
        }
        public void Reset()
        {
            foreach (var avatar in Avatars)
                avatar.Dispose();
            Avatars.Clear();
            BaseAvatar.Root.SetActive(true);
        }

        public void Setup(RuntimeGltfInstance baseAvatar)
        {
            if (baseAvatar is null) return;
            BaseAvatar = baseAvatar;

            foreach (var avatar in Avatars)
                SetConstraint(avatar);
        }

        public void ChangeActiveAvatar()
        {
            if (ConstraintAvatar != null)
                ConstraintAvatar.Root.SetActive(false);

            if (Avatars.Count == 0)
                AvtiveAvatarNo = 0;
            else
                AvtiveAvatarNo = Avatars.Count < (AvtiveAvatarNo + 1) ? 0 : AvtiveAvatarNo + 1;


            if (AvtiveAvatarNo == 0)
            {
                BaseAvatar.Root.SetActive(true);
                ConstraintAvatar.Root.SetActive(false);
            }
            else
            {
                BaseAvatar.Root.SetActive(false);
                ConstraintAvatar = Avatars[AvtiveAvatarNo - 1];
                ConstraintAvatar.Root.SetActive(true);
            }

            BaseProxy = BaseAvatar.Root.GetComponent<VRMBlendShapeProxy>();
            ConstraintProxy = ConstraintAvatar.Root.GetComponent<VRMBlendShapeProxy>();

            Logger.log.Debug($"AvtiveAvatarNo {AvtiveAvatarNo}");

        }

        private void Update()
        {
            if (BaseAvatar == null) return;
            if (ConstraintAvatar == null) return;
            if (ConstraintAvatar.Root.activeSelf == false) return;

            //BlendShape転送
            foreach (var clip in BaseProxy.BlendShapeAvatar.Clips)
            {
                var value = BaseProxy.GetValue(clip.Key);
                ConstraintProxy.AccumulateValue(clip.Key, value);
                //Logger.log.Debug($"Update {clip.Key} {value} {ConstraintProxy.GetValue(clip.Key)}");
            }
            ConstraintProxy.Apply();
        }


        private void SetConstraint(RuntimeGltfInstance SetAvatar)
        {
            Animator animator = SetAvatar.Root.GetComponent<Animator>();
            Animator banimator = BaseAvatar.Root.GetComponent<Animator>();


            //Hipsのみ位置と回転のコンストレイント
            foreach (HumanBodyBones bones in Enum.GetValues(typeof(HumanBodyBones)))
            {
                try
                {
                    if (bones == HumanBodyBones.Hips)
                        SetParentConstraint(animator.GetBoneTransform(bones), banimator.GetBoneTransform(bones));
                    else
                        SetRotationConstraint(animator.GetBoneTransform(bones), banimator.GetBoneTransform(bones));
                }
                catch
                { }
            }

        }

        private void SetParentConstraint(Transform rig, Transform brig)
        {
            if (rig == null || brig == null) return;

            ParentConstraint rc = rig.gameObject.GetComponent<ParentConstraint>();
            Logger.log.Debug($"setup Avatar ParentConstraint is Null {rc is null}");
            if (rc == null)
                rc = rig.gameObject.AddComponent<ParentConstraint>();

            ConstraintSource csource = new ConstraintSource();
            csource.sourceTransform = brig;
            csource.weight = 1.0f;
            rc.AddSource(csource);
            rc.constraintActive = true;
            rc.SetTranslationOffset(0, new Vector3(0f, rig.transform.position.y - brig.transform.position.y, 0f));
            rc.enabled = true;
        }

        private void SetRotationConstraint(Transform rig, Transform brig)
        {
            Logger.log.Debug($"SetRotationConstraint IsNull {rig is null} {brig is null}");
            if (rig == null || brig == null) return;
            Logger.log.Debug($"SetRotationConstraint Name {rig.name} {brig.name}");

            RotationConstraint rc = rig.gameObject.GetComponent<RotationConstraint>();
            if (rc == null)
                rc = rig.gameObject.AddComponent<RotationConstraint>();

            ConstraintSource csource = new ConstraintSource();
            csource.sourceTransform = brig;
            csource.weight = 1.0f;
            rc.AddSource(csource);
            rc.constraintActive = true;
            rc.enabled = true;
        }


    }
}
