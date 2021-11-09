using UnityEngine;
using UnityEngine.XR;


namespace VMCAvatarMaterialChange
{
    /// <summary>
    /// This class manages the input system, most importantly helping to gate button presses
    /// on the controller, basically debouncing buttons.
    /// </summary>
    public class InputManager : MonoBehaviour
    {
        private InputDevice leftController;
        private InputDevice rightController;
        private bool leftTriggerCanClick;
        private bool leftGripCanClick;
        private bool leftTriggerDown;
        private bool leftGripDown;
        private bool rightTriggerCanClick;
        private bool rightGripCanClick;
        private bool rightTriggerDown;
        private bool rightGripDown;
        private bool isPolling;

        #region Button Polling Methods

        public bool GetLeftTriggerDown()
        {
            return leftTriggerDown;
        }

        public bool GetLeftTriggerClicked()
        {
            bool returnValue = false;
            if (leftTriggerCanClick && leftTriggerDown)
            {
                returnValue = true;
                leftTriggerCanClick = false;
            }
            return returnValue;
        }

        public bool GetRightTriggerDown()
        {
            return rightTriggerDown;
        }

        public bool GetRightTriggerClicked()
        {
            bool returnValue = false;
            if (rightTriggerCanClick && rightTriggerDown)
            {
                returnValue = true;
                rightTriggerCanClick = false;
            }

            return returnValue;
        }


        public bool GetLeftGripDown()
        {
            return leftGripDown;
        }

        public bool GetLeftGripClicked()
        {
            bool returnValue = false;
            if (leftGripCanClick && leftGripDown)
            {
                returnValue = true;
                leftGripCanClick = false;
            }
            return returnValue;
        }

        public bool GetRightGripDown()
        {
            return rightGripDown;
        }


        public bool GetRightGripClicked()
        {
            bool returnValue = false;
            if (rightGripCanClick && rightGripDown)
            {
                returnValue = true;
                rightGripCanClick = false;
            }

            return returnValue;
        }
        #endregion

        #region MonoBehavior Methods

        public void BeginGameCoreScene()
        {
            this.leftController = InputDevices.GetDeviceAtXRNode(XRNode.LeftHand);
            this.rightController = InputDevices.GetDeviceAtXRNode(XRNode.RightHand);

            leftTriggerCanClick = true;
            rightTriggerCanClick = true;
            leftGripCanClick = true;
            rightGripCanClick = true;
            isPolling = true;
            Logger.log.Debug($"BeginGameCoreScene {isPolling}");
        }

        internal void DisableInput()
        {
            isPolling = false;
        }

        private void Update()
        {
            const float pulled = 0.75f;
            const float released = 0.2f;

            if (!isPolling) return;

            this.leftController.TryGetFeatureValue(CommonUsages.trigger, out float leftTriggerValue);
            this.rightController.TryGetFeatureValue(CommonUsages.trigger, out float rightTriggerValue);
            this.leftController.TryGetFeatureValue(CommonUsages.grip, out float leftGripValue);
            this.rightController.TryGetFeatureValue(CommonUsages.grip, out float rightGripValue);

            leftTriggerDown = leftTriggerValue > pulled;
            rightTriggerDown = rightTriggerValue > pulled;
            leftGripDown = leftGripValue > pulled;
            rightGripDown = rightGripValue > pulled;


            if (leftTriggerValue < released) { leftTriggerCanClick = true; }
            if (rightTriggerValue < released) { rightTriggerCanClick = true; }
            if (leftGripValue < released) { leftGripCanClick = true; }
            if (rightGripValue < released) { rightGripCanClick = true; }
        }

        #endregion
    }
}
