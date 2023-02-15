Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00961C636CC
	for <linux-sgx@archiver.kernel.org>; Wed, 15 Feb 2023 15:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbjBOPnE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 15 Feb 2023 10:43:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjBOPm5 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 15 Feb 2023 10:42:57 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD713B3F9
        for <linux-sgx@vger.kernel.org>; Wed, 15 Feb 2023 07:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676475754; x=1708011754;
  h=to:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=1lCx8Hp9vg2jFHjWrXeypS/qLe4EAebHd23JqkqnCHE=;
  b=DjUllpbh0IOjhdO9XQrR0mrwC9nZVU2LAN48NA9rU7yhx7zq2eCLu/io
   f5Kv1QqMqw+r+WlNqcoEoGYPS13Moid0zXQOEy89md5a/JVG/YoV0LKQ7
   mfTDVS4zyInwRC2OEBP4jJOwYaCDHQfyKv52GuGRYMQ7WYBkAYEq/x0tR
   GZlmpyEivdqdCNLISGO7tMEHgKib20rteV8QT/DDO+vRQlVpy9nHY1zJl
   nrdb5Bubl8Lp8WwERdfufVL0iZmWG5Iu4vMR0KqNcK+xET0rh+uDpvg2c
   hrbjrR4S6TFqDJFyOtqUBVh4kWfjAPKDAyt4kqTZ9MT2xGhtzxQAtxGR0
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="396079930"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="396079930"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 07:42:32 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="812487960"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="812487960"
Received: from hhuan26-mobl.amr.corp.intel.com ([10.212.105.30])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 15 Feb 2023 07:42:31 -0800
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Huang, Kai" <kai.huang@intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
References: <20230128045529.15749-1-haitao.huang@linux.intel.com>
 <20230128045529.15749-2-haitao.huang@linux.intel.com>
 <20230128045529.15749-3-haitao.huang@linux.intel.com>
 <3c7b4f7bf3e7c2a213662b1c9fdaa979050a9327.camel@intel.com>
 <op.10dekzjhwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <39903b057751d963e4e9b2a8cd5271fe3c102509.camel@intel.com>
 <op.10dk8lsjwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <c37bb20995f234aa724724a06c96c76f18252e66.camel@intel.com>
 <op.10d2otjlwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <ef4087489625b0f8403c38e61348010dba62f623.camel@intel.com>
Date:   Wed, 15 Feb 2023 09:42:30 -0600
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.10ey84qywjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <ef4087489625b0f8403c38e61348010dba62f623.camel@intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 15 Feb 2023 02:51:23 -0600, Huang, Kai <kai.huang@intel.com> wrote:

>> > > >
>> >
>> > Since sgx_mmap() can happen before enclave is created, calculating the
>> > vm_pgoff
>> > from enclave_base is conceptually wrong.  Even if you really want to  
>> do
>> > it, it
>> > should be:
>> >
>> > 	if (enclave_has_initialized())
>> > 		vma->vm_pgoff = ...;
>>
>> I got your point now. I can add a condition to test the SGX_ENCL_CREATED
>> bit. However, we still have a hole if we must handle the sequence
>> mmap(..., enclave_fd) being called before ECREATE ioctl. We can't leave
>> vm_pgoff not set for those cases.
>>
>> Since no one does that so far, can we explicitly return an error from
>> sgx_mmap when that happens?
>> Other suggestions?
>
> As I replied to patch 4/4, I believe userspace should pass the correct  
> pgoff in
> mmap().  It's wrong to always pass 0 or any random value.
>
> If userspace follow the mmap() rule, you won't need to manually set  
> vm_pgoff
> here (which is hacky IMHO).  Everything works fine.
>

SGX driver was following MAP_ANONYMOUS semantics. If we change that, it'd  
break current usage/ABI.

I still think returning error for cases mmap(..., enclave_fd) if enclave  
is not created would be less intrusive change.

Haitao
