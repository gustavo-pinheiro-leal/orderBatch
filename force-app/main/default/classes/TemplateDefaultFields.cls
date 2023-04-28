public with sharing class TemplateDefaultFields {
	public interface FieldDefaults {
		Map<String, Object> getFieldDefaults(Decimal countSObjectCreated);
	}

	public class AccountDefaults implements FieldDefaults {
		public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated) {
			return new Map<String, Object>{
				'Name' => 'Account - Teste' + countSObjectCreated
			};
		}
	}

	public class OrderDefaults implements FieldDefaults {
		public Map<String, Object> getFieldDefaults(Decimal countSObjectCreated) {
			return new Map<String, Object>{
				'EffectiveDate' => Date.today(),
				'Status' => 'Draft'
			};
		}
	}

	public class ContentVersionDefaults implements FieldDefaults{
		public Map<string, Object> getFieldDefaults(Decimal countSObjectCreated){
			return new Map<String, Object>{
				'Title' => 'Test File ' + countSObjectCreated,
				'PathOnClient' => 'Test File' + countSObjectCreated + '.txt',
				'VersionData' => Blob.valueOf('Test data'), 
				'IsMajorVersion' => true
			};
		}
	}
}