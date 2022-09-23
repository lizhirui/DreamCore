using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace TreeViewMagic
{
    #pragma warning disable CS8600
    #pragma warning disable CS8602
    #pragma warning disable CS8603
    #pragma warning disable CS8604
    #pragma warning disable CS8618
    public partial class ObjectInTreeView : UserControl
    {
        public ObjectInTreeView()
        {
            InitializeComponent();
        }
 
        public object? ObjectToVisualize
        {
            get { return (object)GetValue(ObjectToVisualizeProperty); }
            set { SetValue(ObjectToVisualizeProperty, value); }
        }
        public static readonly DependencyProperty ObjectToVisualizeProperty =
            DependencyProperty.Register("ObjectToVisualize", typeof(object), typeof(ObjectInTreeView), new PropertyMetadata(null, OnObjectChanged));
 
        private static void OnObjectChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            TreeNode tree = TreeNode.CreateTree(e.NewValue);
            //(d as ObjectInTreeView).TreeNodes = new List<TreeNode>() { tree };
            (d as ObjectInTreeView).TreeNodes = tree.Children;
        }
 
        public List<TreeNode> TreeNodes
        {
            get { return (List<TreeNode>)GetValue(TreeNodesProperty); }
            set { SetValue(TreeNodesProperty, value); }
        }
        public static readonly DependencyProperty TreeNodesProperty =
            DependencyProperty.Register("TreeNodes", typeof(List<TreeNode>), typeof(ObjectInTreeView), new PropertyMetadata(null));
    }
}
