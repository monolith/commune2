Given /^the following comment records?$/ do |table|

  # USAGE EXAMPLE #########################################
  # | commentator | comment on             | comment    | #
  # | bob         | idea "Bobs great idea" | Hi         | # 
  # | monolith    | idea "Bobs great idea" | hello      | # 
  #########################################################
  
  Comment.destroy_all
    
  table.hashes.each do |attributes|
    comment = attributes.dup
    
    # comment on is required by this code... or this piece of code will break
    tmp = comment.delete("comment on").split
    class_name = tmp.shift
    commentable = { :commentable_type => class_name, :title => tmp.join(" ").gsub("\"","") }
    
    if attributes[:commentator] 
      commentator = { :login => attributes[:commentator] } 
      comment.delete("commentator")
    end

    # see blueprints.rb in features/support for details        
    create_comment!( { :comment => comment, :commentator => commentator, :commentable => commentable } )
  end

  
end

