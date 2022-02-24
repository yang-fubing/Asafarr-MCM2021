# “FAST”自动反射球面的形状调节
### 2021全国大学生数学建模竞赛上海二等奖

500 米口径球面射电望远镜“FAST”有特殊的使用功能，由主索节点构成的主动反
射面主要分为两个状态——基准态（球面）、工作态（近似旋转抛物面）。“FAST”在工
作中，支撑其结构的控制众多，而本论文主要研究其主动反射面的形状调节策略。


问题 1 是一个优化问题——在考虑反射面板调节因素（促动器径向伸缩范围为-
0.6～+0.6 米）的情况下，满足约束的理想抛物面可能不唯一，需要制定合理的优化指标
择优选取。“FAST”主索网受下拉索-促动器结构施加的位移影响实现由基准球面到工
作抛物面的变形，该位移沿径向且存在严格的运动范围限制，因此变位时促动器的运动
行程是判定理想抛物面优劣的指标之一；此外，对于一个理想抛物面更重要的是，获得
天体电磁波经反射面反射后的最佳接收效果。综上两点，我们定义了三项优化指标（1.
促动器的总行程 2. 工作抛物面与基准球面之间的距离幅值 3. 工作抛物面的相对反射有
效值），结合逐步求精算法，在满足反射面板调节约束的抛物面中择优，确定理想抛物
面方程为：(x + y)2 = 560.84(z + 300.81)。


问题 2 是问题 1 的变形——我们经过计算，找到了在问题 2 条件下位于直线 SC 上
的主索节点：D27。我们做出假设：基准球面和工作抛物面都是关于轴对称的。通过乘
以转移矩阵，将主索网沿中心转动，使得问题 2 可以在问题 1 的环境中求解，问题得
到了简化。最后通过乘以逆矩阵，将主索网还原，得到理想抛物面方程：[(sin36.795° +
cos36.795°sin78.169°)x + (sin36.795°sin78.169° − cos36.795°)y − cos78.169°z]2 = 560.84
(cos78.169°cos36.795°x + sin36.795°cos78.169°y + sin78.169°z + 300.81)]。调节后反射面
300 米口径内的主索节点编号、位置坐标、各促动器的伸缩量等结果保存在 result.xlsx
中，附录 B 展示了该文件的部分截图。


问题 3 重在计算——我们首先计算了照明区域内每块反射面板的法向量，根据光的
反射原理，将每块反射面板的三个顶点投影到馈源舱平面得到一块三角区域，再计算三
角区域与馈源舱有效区域的重叠部分面积。将工作抛物面照明区域内的所有反射面板投
射后计算出的重叠部分面积求和，即可得到馈源舱的接收比：1.1079%。


关键字： 加权评分法 优化指标 逐步求精
