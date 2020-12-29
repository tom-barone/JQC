class UpdateApplicationReferenceNumbersWithPaddedZeros < ActiveRecord::Migration[
  6.0
]
  def up
    # Add padded zeros to the reference number column
    execute "
      update applications a1 inner join applications a2 on a1.id = a2.id
        set a1.reference_number = CONCAT(
            UCASE(REGEXP_SUBSTR(replace(a2.reference_number,'cancelled ', ''), '^C|^LG|^PC|^Q|^RC|^SC')),
            LPAD(REGEXP_SUBSTR(a2.reference_number, '[:digit:]+'),5,'0'),
            REPLACE(
                Replace(
                    REPLACE(
                        REPLACE(UCASE(a2.reference_number), 'PC ', 'PC'),
                        'Q ', 'Q'),
                            'LG ', 'LG'),
                UCASE(CONCAT(
                    REGEXP_SUBSTR(a2.reference_number, '^C|^LG|^PC|^Q|^RC|^SC'), 
                    REGEXP_SUBSTR(a2.reference_number, '[:digit:]+')
                )),
                ''
            )
          )
    "
  end
end
