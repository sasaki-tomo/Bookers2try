class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { minimum: 2, maximum: 20 }

  validates :introduction, length: { maximum: 50 }

  attachment :profile_image #プロフィール画像投稿

  has_many :books, dependent: :destroy #Bookモデルと1：Nの関係
  
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
 
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy # フォローしている人を取得
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy # フォローされている人を取得
  has_many :following_user, through: :follower, source: :followed # 自分がフォローしている人
  has_many :follower_user, through: :followed, source: :follower # 自分をフォローしている人
  
  # ユーザーをフォローする
def follow(user_id)
  follower.create(followed_id: user_id)
end

# ユーザーのフォローを外す
def unfollow(user_id)
  follower.find_by(followed_id: user_id).destroy
end

# フォロー確認
def following?(user)
  following_user.include?(user)
end
  
  def favorited_by?(book_id)
      favorites.where(book_id: book_id).exists?
  end
  
  
end
