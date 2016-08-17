创建一个空对象,绑定到武器合适的挂接点上;
将这个控对象的Layer设置为WeaponTrail(如果没有则需要添加);
为对象添加WeaponTrail脚本;
在对象下创建若干子对象,这些子对象是用来标示要产生刀光的轮廓,然后将他们拖到WeaponTrail组件的Shap Points里面;
Time为产生拖尾的长度;

为MeshRender添加一个材质,材质Shader指定为Custom/Distort,参数意义为: 
Brightness 亮度
Main Texture是程序自动设置
Nosie Texture为一张特殊处理的扭曲贴图,目前固定
Distort为扭曲强度
Alpha为刀光透明度


在角色对象上添加WeaponTrailController脚本,将上面创建的刀光对象拖到Weapon Trails里



