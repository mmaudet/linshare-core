/*
 *    This file is part of Linshare.
 *
 *   Linshare is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU Affero General Public License as
 *   published by the Free Software Foundation, either version 3 of
 *   the License, or (at your option) any later version.
 *
 *   Linshare is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Affero General Public License for more details.
 *
 *   You should have received a copy of the GNU Affero General Public
 *   License along with Foobar.  If not, see
 *                                    <http://www.gnu.org/licenses/>.
 *
 *   (c) 2008 Groupe Linagora - http://linagora.org
 *
*/
package org.linagora.linshare.core.domain.entities;

import java.util.HashSet;
import java.util.Set;


public class TagEnum extends Tag {
	public TagEnum() {
	}
	
	private Boolean notNull;
	
	private Set<TagEnumValue> enumValues = new HashSet<TagEnumValue>();
	
	public void setNotNull(Boolean value) {
		this.notNull = value;
	}
	
	public Boolean getNotNull() {
		return notNull;
	}
	
	public void setEnumValues(Set<TagEnumValue> value) {
		this.enumValues = value;
	}
	
	public Set<TagEnumValue> getEnumValues() {
		return enumValues;
	}
	
}