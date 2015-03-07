require 'spec_helper'

describe ChildFormHelper do
  let(:value) { 'Add child' }
  let(:form) { double Object }

  describe '#remove_child_link' do
    let(:hide_class) { 'hide_class' }
    let(:confirm_question) { 'Are you sure?' }

    before do
      expect(form).to receive(:hidden_field).with(:_destroy).and_return('<hidden-field/>')
    end

    it 'should return hidden _destroy field and button with onclick call to remove_fields javascript' do
      expect(helper.remove_child_link(value, form, hide_class, confirm_question)).
          to eq("<hidden-field/><input type=\"button\" value=\"Add child\" onclick=\"remove_fields(this, &#39;hide_class&#39;, &#39;Are you sure?&#39;);\" />")
    end
  end

  describe '#add_child_link' do
    let(:method) { 'method' }

    before do
      expect(helper).to receive(:new_child_fields).with(form, method).and_return('<div id="f">fields</div>')
    end

    context 'without id' do
      it 'should return button with onclick call to insert_fields javascript as escaped' do
        expect(helper.add_child_link(value, form, method)).
            to eq('<input type="button" value="Add child" onclick="insert_fields(this, &quot;method&quot;, &quot;&lt;div id=\\&quot;f\\&quot;&gt;fields&lt;\\/div&gt;&quot;);" />')
      end
    end

    context 'with id' do
      let(:id) { 'my-id' }
      it 'should return button with id and onclick call to insert_fields javascript' do
        expect(helper.add_child_link(value, form, method, id)).
            to eq('<input type="button" value="Add child" onclick="insert_fields(this, &quot;method&quot;, &quot;&lt;div id=\\&quot;f\\&quot;&gt;fields&lt;\\/div&gt;&quot;);" id="my-id" />')
      end
    end
  end
end