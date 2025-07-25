好的，这是您的测试指南的中文翻译：

# 测试指南

## 基本原则

  * **单元测试应保持小巧、快速和独立。**
      * 每个测试只验证一个功能或行为。
      * 避免测试之间的依赖关系。
  * **测试也用作文档。**
      * 测试名称应清楚地表明正在测试的内容。
      * 测试代码应作为如何使用实现的示例。
  * **当存在依赖对象时，应尽可能使用真实的产品代码进行测试。** 仅在不可避免时才使用测试替身（Test Doubles）。

-----

## 结构

  * 如果目标代码位于 `Editor/` 目录下（用于编辑器扩展），则将测试代码放在 `Tests/Editor/` 目录下（编辑模式测试）。
  * 如果目标代码位于 `Runtime/` 目录下，则将测试代码放在 `Tests/Runtime/` 目录下（运行模式测试）。
  * 创建与被测类相对应的目录结构和测试类。
  * 如果在测试代码中创建了用于测试的替身类（Stub、Spy、Dummy、Fake、Mock），请将它们放在 `Tests/Editor/TestDoubles/` 或 `Tests/Runtime/TestDoubles/` 目录中。
  * 如果创建了用于测试代码的场景文件，请将它们放在 `Tests/Scenes/` 目录中。

-----

## 命名规范

  * **测试程序集名称** 应为目标程序集名称 + ".Tests"。
  * **测试代码的命名空间** 应与目标的命名空间相同。
  * **测试类名称** 应为目标类名称 + "Test"。例如：`public class CharacterControllerTest`
  * **测试方法名称** 应使用 `方法名_条件_预期结果` 的格式，并用下划线连接。例如：`public void TakeDamage_WhenHealthIsZero_CharacterDies()`
  * 明确将被测系统命名为 `sut`，实际值命名为 `actual`，期望值命名为 `expected`，以明确其角色。
  * 使用**测试替身**时，根据 xUnit 测试模式（xUTP）的定义，使用 `stub`、`spy`、`dummy`、`fake` 或 `mock` 其中一个作为前缀。

-----

## 设计

  * 测试使用基于 NUnit 3 的 **Unity Test Framework**。请参阅：[Unity Test Framework 手册](https://docs.unity3d.com/Packages/com.unity.test-framework@1.4/manual/index.html)
  * 为测试类添加 `[TestFixture]` 特性。
  * **测试方法结构：**
      * 遵循 **Arrange、Act、Assert** (安排、执行、断言) 模式。
      * 每个部分之间用空行隔开。无需注释。
  * 每个测试方法只使用**一个断言（Assert）**。
  * 对于断言，使用**约束模型 (`Assert.That`)**。请参阅文档以使用最合适的约束。请参阅：[NUnit 约束](https://docs.nunit.org/api/NUnit.Framework.Constraints.html)
  * 不要为 `Assert.That` 指定 `message` 参数。测试名称和约束应足以传达意图。
  * 测试代码应为**简单的单一路径**。
      * 切勿在测试代码中使用 `if`、`switch`、`for`、`foreach` 或三元运算符。
  * 积极使用**参数化测试**。
      * Arrange 部分不同但 Act 和 Assert 部分相同的测试，可以使用 `[TestCase]`、`[TestCaseSource]`、`[Values]` 和 `[ValueSource]` 等特性进行参数化。
      * 也可以使用 `[ParametrizedIgnore]` 特性排除某些组合。
  * 积极使用**创建方法模式**来创建测试中使用的对象。例如：`private GameObject CreateSystemUnderTestObject()`
      * 即使对象被保存在私有字段中以便在 `TearDown` 中进行资源清理，在测试方法中也应始终使用创建方法的返回值。
  * 每个测试必须能够**独立执行**，不依赖于其他测试的结果。
  * 如果在测试期间实例化了 `GameObject`，请向测试方法添加 `[CreateScene]` 特性。如果已存在 `[LoadScene]` 特性，则无需添加。
  * 避免随便使用 `LogAssert` 验证日志消息。如有必要，应创建并使用一个 **Spy** 来代替。
  * 在异步测试中，不要使用 `Delay` 或 `Wait` 来暂停指定时间。要等待一帧，可以使用 `yield return null`。
  * 在验证异步方法中是否抛出异常时，应使用 **try-catch 块**而不是 `Throws` 约束来确认异常被抛出（这是 Unity Test Framework 的一个限制）。
    ```csharp
    try
    {
        await Foo.Bar(-1);
        Assert.Fail("预期会抛出异常，因此此测试应失败。");
    }
    catch (ArgumentException expectedException)
    {
        Assert.That(expectedException.Message, Is.EqualTo("Semper Paratus!"));
    }
    ```

-----

## 注释

  * 测试代码不需要 XML 文档注释。

-----

## 测试执行

  * 在运行测试之前，请确保 Unity 编辑器中没有编译错误。
  * 通过 MCP 在 Unity 编辑器的 Test Runner (测试运行器) 中运行测试。
  * 积极使用过滤器以最小化执行的测试数量。可以利用“命名规范”部分中定义的命名约定。

-----

## 解读测试结果

根据以下标准解读测试结果：

  * **通过 (Passed)**：测试成功。
  * **失败 (Failed)**：测试失败。需要调查和修正。
  * **不确定 (Inconclusive)**：测试的先决条件未能满足。应视同失败处理。
  * **跳过 (Skipped)**：该测试被指定跳过。可以忽略。

按以下步骤处理失败的测试：

1.  检查错误信息以确定原因。
2.  分析期望值与实际值之间的差异。
3.  修复后，重新运行相同的测试以确认修复成功。
4.  如果连续失败，请同时审查测试代码和实现代码。
5.  如果连续两次失败，请总结情况并向用户寻求指导。