{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('products_variants_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_products_hashid',
        adapter.quote('id'),
        'sku',
        boolean_to_string('on_sale'),
        'quantity',
        'parent_id',
        object_to_string(adapter.quote('attributes')),
        'sale_price',
        'regular_price',
    ]) }} as _airbyte_variants_hashid,
    tmp.*
from {{ ref('products_variants_ab2') }} tmp
-- variants at products/variants
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

