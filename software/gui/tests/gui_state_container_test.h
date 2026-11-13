/* Copyright 2020-2021, RespiraWorks

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

#pragma once

#include <QCoreApplication>
#include <QQmlComponent>
#include <QQmlContext>
#include <QQmlEngine>
#include <QtTest>
#include <memory>

#include "gui_state_container.h"

class GuiStateContainerTest : public QObject {
  Q_OBJECT
 public:
  GuiStateContainerTest() = default;
  ~GuiStateContainerTest() = default;

 private slots:
  void initTestCase() {}
  void cleanupTestCase() {}

  void testInit() { GuiStateContainer ch(DurationMs(0), DurationMs(0)); }

  void testQmlModeSelectionUpdatesOutgoingStatus() {
    GuiStateContainer state(DurationMs(0), DurationMs(0));
    QQmlEngine engine;
    engine.rootContext()->setContextProperty("state", &state);
    QQmlComponent component(&engine);
    component.setData(
        "import QtQml\n"
        "QtObject { function selectMode(value) { state.commanded_mode = value } }",
        QUrl());
    QVERIFY2(component.isReady(), qPrintable(component.errorString()));
    std::unique_ptr<QObject> object(component.create());
    QVERIFY2(object != nullptr, qPrintable(component.errorString()));
    QSignalSpy changes(&state, &GuiStateContainer::params_changed);
    QVERIFY(QMetaObject::invokeMethod(
        object.get(), "selectMode",
        Q_ARG(QVariant, QVariant(static_cast<int>(GuiStateContainer::PRESSURE_ASSIST)))));
    QCOMPARE(changes.count(), 1);
    QCOMPARE(state.GetGuiStatus().desired_params.mode, VentMode::VentMode_PRESSURE_ASSIST);
  }
};
