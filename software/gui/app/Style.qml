pragma Singleton
import QtQuick 2.11
import Respira 1.0

/*!
    \qmltype Style
    \brief Singleton defining all styles of the App.

    It will hold all UI style definitions into a single
    place, making it easy to everyone, including designers
    to contribute.

    For now its defining two themes: lightTheme and darkTheme.
    Those themes it will be defining colors, sizes and other
    style aspects.

    A propery theme will define the current used theme, that could
    be changed at runtime.
*/
QtObject {

    property var theme: darkTheme

    property var lightTheme: QtObject {
        // TODO get all values
    }

    property var darkTheme: QtObject {

        property QtObject color: QtObject {
            property color primary: "#42D7E8"
            property color windowBackground: "#0A1017"
            property color surface: "#0F1922"
            property color readingSurface: "#14212C"
            property color border: "#273947"
            property color borderBright: "#375062"
            property color modalBackground: "#111C26"
            property color modalHeaderColor: "#16313D"
            property color modalButton: "#1B2B3A"
            property color modalButtonHighlighted: "#284351"

            property color headerButton: "#1A2A38"
            property color headerButtonHighlighted: "#284351"

            property color radioButtonColor: "white"
            property color radioButtonHighlightedColor: "#38CFE0"

            property color textPrimary: "#F3F7FB"
            property color textAlternative: "#93A8B9"

            property color alarmHighBright: "#C6393F"
            property color alarmHighDim: "#521F28"

            property color alarmMediumBright: "#F0D95D"
            property color alarmMediumDim: "#656231"

            property color alarmLowBright: "#4586A3"
            property color alarmLowDim: "#204050"

            property color normalGraphLine: "#38CFE0"
            property color normalGraphArea: "#1038CFE0"
            property color pressureGraphLine: "#42D7E8"
            property color flowGraphLine: "#5DE4B9"
            property color volumeGraphLine: "#B6A6FF"

            property var parameterBackgroundByPriority: function(p) {
              var c = Style.theme.color
              switch (p) {
                  case AlarmPriority.HIGH: return c.alarmHighBright;
                  case AlarmPriority.MEDIUM: return c.alarmMediumBright;
                  case AlarmPriority.LOW: return c.alarmLowBright;
                  default: return "transparent";
              }
            }

            property var timeSeries: QtObject {
              property var lineByPriority: function(p) {
                var c = Style.theme.color
                switch (p) {
                    case AlarmPriority.HIGH: return c.alarmHighBright;
                    case AlarmPriority.MEDIUM: return c.alarmMediumBright;
                    case AlarmPriority.LOW: return c.alarmLowBright;
                    default: return c.normalGraphLine;
                }
              }
              property var areaByPriority: function(p) {
                var c = Style.theme.color
                switch (p) {
                    case AlarmPriority.HIGH: return c.alarmHighDim;
                    case AlarmPriority.MEDIUM: return c.alarmMediumDim;
                    case AlarmPriority.LOW: return c.alarmLowDim;
                    default: return c.normalGraphArea;
                }
              }
            }
        }

        property QtObject font: QtObject {

            property font textHeaderSubtitle: Qt.font({
                                                          family: "Noto Sans",
                                                          pixelSize: 32,
                                                          letterSpacing: 0,
                                                          weight: Font.Normal
                                                      })

            property font textHeaderTitle: Qt.font({
                                                       family: "Noto Sans",
                                                       pixelSize: 48,
                                                       letterSpacing: 0,
                                                       weight: Font.Normal
                                                   })
            // Font for number display on the stepped button
            property font modalButton: Qt.font({
                                                   family: "Noto Sans",
                                                   pixelSize: 32,
                                                   letterSpacing: 0,
                                                   weight: Font.Normal
                                               })

            property font modalHeader: Qt.font({
                                                   family: "Noto Sans",
                                                   pixelSize: 48,
                                                   letterSpacing: 0,
                                                   weight: Font.Normal
                                               })

            property font modalTitle: Qt.font({
                                                  family: "Noto Sans",
                                                  pixelSize: 20,
                                                  letterSpacing: 0,
                                                  weight: Font.Normal
                                              })

            property font modalContent: Qt.font({
                                                    family: "Noto Sans",
                                                    pixelSize: 16,
                                                    letterSpacing: 0,
                                                    weight: Font.Normal
                                                })

            property font headerButton: Qt.font({
                                                    family: "Noto Sans",
                                                    pixelSize: 20,
                                                    letterSpacing: 0,
                                                    weight: Font.Normal
                                                })

            property font parameterButton: Qt.font({
                                                       family: "Noto Sans",
                                                       pixelSize: 20,
                                                       letterSpacing: 0,
                                                       weight: Font.Normal
                                                   })

            property font parameterButtonNotation: Qt.font({
                                                               family: "Noto Sans",
                                                               pixelSize: 16,
                                                               letterSpacing: 0,
                                                               weight: Font.Normal
                                                           })

            property font parameterButtonValue: Qt.font({
                                                            family: "Noto Sans",
                                                            pixelSize: 48,
                                                            letterSpacing: 0,
                                                            weight: Font.DemiBold
                                                        })

            property font parameterDisplay: Qt.font({
                                                        family: "Noto Sans",
                                                        pixelSize: 16,
                                                        letterSpacing: 0,
                                                        weight: Font.Normal
                                                    })

            property font parameterDisplayValue: Qt.font({
                                                             family: "Noto Sans",
                                                             pixelSize: 48,
                                                             letterSpacing: 0,
                                                             weight: Font.DemiBold
                                                         })

            property font parameterPopupDisplayValue: Qt.font({
                                                                  family: "Noto Sans",
                                                                  pixelSize: 160,
                                                                  letterSpacing: 0,
                                                                  weight: Font.Bold
                                                              })
            property font graphLabel: Qt.font({
                                                  family: "Noto Sans",
                                                  pixelSize: 16,
                                                  letterSpacing: 0,
                                                  weight: Font.Normal
                                              })
        }

    }

    // TODO: should margins and fonts be part of a theme or a
    // separate entity?
    property QtObject margin: QtObject {
        property int normal: 10
    }

    // Font for number display on the stepped button
    property font stepButtonFont: Qt.font({
                                              family: "Times New Roman",
                                              weight: Font.DemiBold,
                                              bold: true,
                                              pixelSize: 38
                                          })

    // Font for number display on the stepped button
    property font clockFont: Qt.font({
                                         family: "Noto Sans",
                                         pixelSize: 16,
                                         letterSpacing: 0,
                                         weight: Font.Normal
                                     })
}
