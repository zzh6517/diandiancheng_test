class SessionsController < ApplicationController
#初始化Ruby China登录页面url
  LOGIN_URI = 'https://ruby-china.org/account/sign_in'

#用来显示登陆后的页面(没有经过格式化,显示较粗糙)
  def index
  end

#打开登陆页面
  def new
    begin
      #使用Mechanize获取ruby china登陆页面的信息，得到login_page实例
      login_page = Mechanize.new.get(LOGIN_URI)
      $logined_page = login_page
    rescue => e
      redirect_to new_session_path
    end
  end

#登录
  def create
    begin
      params[:notice] = []  #用来记录登录后的返回信息
      login_form = $logined_page.forms.last  #登录页面只有搜索和用户登录两个表单，所以取最后一个表单
      #插入相应值
      login_form.fields[1].value = params[:email]
      login_form.fields[2].value = params[:password]
      #向Ruby China提交登录表单
      logined_page = login_form.submit
      logger.info logined_page.body
      #将返回的页面body元素赋于params[:notice]方便index显示登录成功或者失败的页面
      params[:notice] << logined_page.body
      render :index
    rescue => e
      render :new
    end
  end

end
