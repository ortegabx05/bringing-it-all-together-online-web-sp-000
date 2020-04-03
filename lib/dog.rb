class Dog
  
  attr_accessor :name, :breed, :id


   def initialize(id: nil,name:,breed:)
        @name = name
        @breed = breed
        @id = id
   end
    
   def self.create_table
        sql = <<-SQL
            CREATE TABLE dogs (
                id INTEGER PRIMARY KEY,
                name TEXT,
                breed TEXT
            )
        SQL
        DB[:conn].execute(sql)
   end
   
   def self.drop_table
        DB[:conn].execute('DROP TABLE dogs')
   end
       
   def save
        sql = <<-SQL
            INSERT INTO dogs (name,breed)
            VALUES (?,?)
        SQL
        DB[:conn].execute(sql,self.name,self.breed)
        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
        self
   end
   
   def self.create(name:name,breed:breed)
        dog_attributes = {name: name,breed: breed}
        dog = Dog.new(dog_attributes)
        dog.save
   end
   
   def self.new_from_db(row)
       new_dog = create(name:row[1],breed:row[2])
       new_dog.id = row[0]
       new_dog
   end
   
   def self.find_by_id(sought_id)
        row = DB[:conn].execute("SELECT * FROM dogs WHERE id = ?",sought_id)[0]
        new_dog = Dog.new(id:sought_id,name:row[1],breed:row[2])
        new_dog
   end

  end