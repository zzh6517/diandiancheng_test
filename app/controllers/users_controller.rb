class UsersController < ApplicationController
#初始化Ruby China注册页面url
  SIGN_UP_URI = 'https://ruby-china.org/account/sign_up'

#用来显示注册后的页面(没有经过格式化,显示较粗糙)
  def index
  end

#用户注册
  def new
    begin
      #使用Mechanize获取ruby china注册页面的信息，得到sign_in_page实例
      sign_in_page = Mechanize.new.get(SIGN_UP_URI)
      #为保证获取注册页面时的验证码和提交注册表单后的验证码一致，使用全局变量$page(一般不建议使用全局变量)将sign_in_page实例保存下来供create动作使用
      $page = sign_in_page
      #将获取的注册页面的验证码图片赋值给@image_url传给前台注册页面使用
      #在全自动爬虫处理应该使用图片识别插件识别验证码图片中的符号并自动填入，时间较紧没有实现，索性把图片取出来供注册使用
      @image_url = sign_in_page.search("img.rucaptcha-image")[0].attr('src')
    rescue => e
      redirect_to "/"
    end
  end

#此处是注册的另一种实现方法，原理类似，只是都放在new里处理了，但是很遗憾，两种方法都返回验证码错误,
#ruby china验证码应该是用js刷新的，所以获取或刷新注册页面的时候验证码没有对应上，暂时没有更多的时间解决这个问题
=begin
  def new
    sign_in_page = Mechanize.new.get(SIGN_UP_URI)
    @image_url = sign_in_page.search("img.rucaptcha-image")[0].attr('src')
    if params[:user_login] && params[:user_name] && params[:user_email] && params[:user_password] && params[:user_password_confirmation] && params[:captcha]
      sign_in_form = sign_in_page.forms.last
      sign_in_form.fields[1].value = params[:user_login]
      sign_in_form.fields[2].value = params[:user_name]
      sign_in_form.fields[3].value = params[:user_email]
      sign_in_form.fields[5].value = params[:user_password]
      sign_in_form.fields[6].value = params[:user_password_confirmation]
      sign_in_form.fields[7].value = params[:captcha]
      signed_page = sign_in_form.submit
    end
  end
=end

  def create
    begin
      params[:notice] = [] #用来记录注册后的返回信息
      sign_in_form = $page.forms.last  #注册页面只有搜索和用户注册两个表单，所以取最后一个表单
      #插入相应值
      sign_in_form.fields[1].value = params[:user_login]
      sign_in_form.fields[2].value = params[:user_name]
      sign_in_form.fields[3].value = params[:user_email]
      sign_in_form.fields[5].value = params[:user_password]
      sign_in_form.fields[6].value = params[:user_password_confirmation]
      sign_in_form.fields[7].value = params[:captcha]
      #向Ruby China提交表单
      signed_page = sign_in_form.submit
      logger.info signed_page.body
      #将返回的页面body元素赋于params[:notice]方便index显示注册成功或者失败的消息
      params[:notice] << signed_page.body
      render :index
    rescue => e
      render :new
    end
  end

end
