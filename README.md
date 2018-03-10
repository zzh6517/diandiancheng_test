# README

* Ruby version:  ruby => 2.3.4

* Rails version:  rails => 5,1,4

* Database:  postgresql  (由于示例部署在heroku上，所以数据库使用的是postgresql)

* 访问地址（由于使用的是heroku，有时可能需要挂vpn，第一次点开时稍微有点慢，大概5秒左右的时间）: https://rocky-wildwood-71695.herokuapp.com/

*由于时间原因，功能实现的较为简陋，以下为简单介绍：

一.打开访问地址后会链接到根页面，根页面中有一个页码的表单，填写页码后，点击提交按钮可获取Ruby China社区板块相应页码的话题及话题创建者信息，是以简单的表格形式列出，操作列可点击查看评论内容，点击后可获取该话题的评论者及评论内容信息。

简单实现原理：
1.使用Mechanize.new.get(uri)获取Ruby China社区的话题板块内容；
2.使用mechanize自带的nokogiri解析页面内容；
3.使用nokogiri获取话题创建者和话题title及话题链接href，并分别放在@topics、@users、@hrefs变量中（均为数组形式）；
4.解析出的话题链接href中含有topic_id，所以将href内容处理获取每个话题的topic_id；
5.将topic_id与url相结合获取某个话题的详细信息（带有评论）,然后同使用mechanize自带的nokogiri解析话题详情页，将所有评论内容和评论者取出并在页面中遍历出来。

二.根页面有注册链接，点击注册链接后，跳转到注册页面，会显示出注册表单和注册验证码，注册成功后会将注册后的页面以html原生代码的形式展示出来（注册之后的页面没有详细处理，能看出注册成功还是失败）。

简单实现原理：
1.与一相同，均使用Mechanize操作；
2.sign_in_page = Mechanize.new.get(SIGN_UP_URI)获取注册页面；
3.将验证码图片提取出来:@image_url = sign_in_page.search("img.rucaptcha-image")[0].attr('src')供注册页面使用（在全自动爬虫处理时应该使用图片识别插件识别验证码图片中的符号并自动填入，时间较紧没有实现，索性把图片取出来供注册使用）；
4.Ruby China注册页面有搜索和用户注册两个表单，所以取最后一个表单sign_in_form = sign_in_page.forms.last；
5.使用sign_in_form.fields[x].value = params[:user_sign]为表单赋值；
6.sign_in_form.submit提交表单并获取Ruby China的返回信息；

三.根页面有登录链接，点击登录链接可跳转到登录页面，填写登录表单提交后跳转到登录成功或者登录失败的页面（页面没有详细处理，登录成功后会将ruby china首页内容以html形式显示出来，否则，将ruby china的登录页面以html的形式显示出来）。

简单实现原理：
1.创建登录用户的回话id(session)；
2.服务器记住登录用户的session后，用户便可有权限访问相应页面；
3.剩下的操作实现原理和一二类似，灵活使用即可；

四.用户的发帖和评论暂未实现，简单描述一下实现方法，用户在登录后应该创建该用户的回话id(session)，以便用户登录后服务器能记住用户的登录状态，使用户有权限访问登录后的页面，之后可以获取Ruby China上的发布新话题页面url，结合一、二、三的操作方式将话题标题和内容填入并提交完成话题发布。

五.评论别的话题时首先取出某个话题的topic_id以便确定该话题，然后根据topic_id及url定位到话题详情页，使用mechanize自带的相应方法在评论区填写评论之后提交完成话题评论。

