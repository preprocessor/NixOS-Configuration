{
  flake.modules.nixos.ramiel =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.logiops ];
      # logitech device controls

      environment.etc."logid.cfg".text = ''
        devices: (
        {
            name: "MX Master 3S";
            smartshift:
            {
                on: true;
                threshold: 30;
                torque: 50;
            };
            hiresscroll:
            {
                hires: false;
                invert: false;
                target: true;
                up: {
                    mode: "Axis";
                    axis: "REL_WHEEL";
                    axis_multiplier: 2.0;
                },
                down: {
                    mode: "Axis";
                    axis: "REL_WHEEL";
                    axis_multiplier: -2.0;
                }
            };
            thumbwheel:
            {
                divert: false; // Enable thumbwheel handling
                invert: true; // Invert the thumbwheel scroll direction
                left:
                {
                    mode: "NoPress"; // Action when thumbwheel is scrolled left
                },
                right:
                {
                    mode: "NoPress"; // Action when thumbwheel is scrolled right
                }
            };
            dpi: 1800; // max=4000

            buttons: (
                {
                    cid: 0xc3;
                    action =
                    {
                        type: "Gestures";
                        gestures: (
                            {
                                direction: "Up";
                                mode: "OnRelease";
                                action =
                                {
                                    type: "Keypress";
                                    keys: ["KEY_UP"];
                                };
                            },
                            {
                                direction: "Down";
                                mode: "OnRelease";
                                action =
                                {
                                    type: "Keypress";
                                    keys: ["KEY_DOWN"];
                                };
                            },
                            {
                                direction: "Left";
                                mode: "OnRelease";
                                action =
                                {
                                    type: "CycleDPI";
                                    dpis: [400, 600, 800, 1000, 1200, 1400, 1600];
                                };
                            },
                            {
                                direction: "Right";
                                mode: "OnRelease";
                                action =
                                {
                                    type: "ToggleSmartshift";
                                }
                            },
                            {
                                direction: "None";
                                mode: "NoPress";
                            }
                        );
                    };
                },
                {
                    cid: 0xc4;
                    action =
                    {
                        type: "Keypress";
                        keys: ["KEY_A"];
                    };
                }
            );
        }
        );
      '';
    };
}
