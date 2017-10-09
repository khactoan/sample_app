Rails.application.routes.draw do
	get 'staticpages/home'
	get 'staticpages/help'
	get 'staticpages/about'
	get 'staticpages/contact'
	root 'static_pages#home'
end
