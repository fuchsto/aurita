
select 
model, asset.asset_id, media_type, doctype, folder, description, relevance 
from asset 
full outer join document_asset on (asset.asset_id = document_asset.asset_id) 
  left join document_asset_info on (document_asset_info.document_asset_id = document_asset.id)
full outer join media_asset on (asset.asset_id = media_asset.asset_id) 
  left join media_asset_info on (media_asset_info.media_asset_id = media_asset.id)

order by model
;
