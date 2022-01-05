Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8924DC433F5
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Jan 2022 00:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiAEAgp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Jan 2022 19:36:45 -0500
Received: from mga05.intel.com ([192.55.52.43]:3517 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbiAEAgn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 4 Jan 2022 19:36:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641343003; x=1672879003;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Ft+rT7HrOA7jRuvDfeMuar2M18nFuqdfki4K/T1Sdjs=;
  b=RvhjZngVx7U4X/mYWZmnIfrblUDd4Z2LXecaTNX+Yqdgt+xuYfBQTgOh
   peMe4Xwn+BLvPfQ2vmJeRr99cblYVnCSFpZBW02Qyyx260twHbqS8EEMM
   C0huobloOID3475EqzQ66iOP5EQGdx4FwFZOx8Hxs76RRi9aVCHBlHWOp
   LsdwPT8vNOLh/PRJz9TNZOKA2Nn5p9zfZG8h2ciVypb7jLdTtwi2qn86U
   bPu+e5y8K3ZSGy69FPSMDQdJYYmZYNFXc0ZCdKGi+1NPpgYP0gh2dXCOo
   fqjNVLDUXUhswEJDNI76zITGQL2kzLuy/kthWEhTliwoaBQDyxW7WSLvA
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="328681799"
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="328681799"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2022 16:36:30 -0800
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="556349543"
Received: from mncallah-mobl.amr.corp.intel.com (HELO [10.209.35.108]) ([10.209.35.108])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2022 16:36:30 -0800
Subject: Re: [PATCH 2/2] x86/sgx: account backing pages
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Kristen Carlson Accardi <kristen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20211220174640.7542-1-kristen@linux.intel.com>
 <20211220174640.7542-3-kristen@linux.intel.com> <YcufxPNV8HleTPB4@iki.fi>
From:   Dave Hansen <dave.hansen@intel.com>
Message-ID: <a2de9239-336c-c4db-3998-e90d6f150634@intel.com>
Date:   Tue, 4 Jan 2022 16:36:28 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YcufxPNV8HleTPB4@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 12/28/21 3:37 PM, Jarkko Sakkinen wrote:
> On Mon, Dec 20, 2021 at 09:46:40AM -0800, Kristen Carlson Accardi wrote:
>> +int sgx_encl_lookup_backing(struct sgx_encl *encl, unsigned long page_index,
>> +			    struct sgx_backing *backing)
>> +{
>> +	return sgx_encl_get_backing(encl, page_index, backing);
>> +}
> Is this wrapping necessary?

Yes, I think so.

> Also, there is ambiguous terminology:
> 
> 1. Local function: "get_backing"
> 2. Exported function: "lookup_backing"

I'm not sure what you're getting at.

There are three important things that you do with backing storage:

1. Allocate it
2. Find it
3. De-allocate (free) it

Right now, the code has a pattern where it does:

	get_backing();
	// do something
	put_backing();

That sure as heck looks like it is allocating and freeing it.  But, it's
actually *maybe* doing an allocation.  The "find it" path also looks
*EXACTLY* the same as the actual allocation path.  You might also recall
that the original code didn't even *have* a (real) free path.

The "wrapping" is really just naming the two different operations that
use the "get" function: lookup and allocate.  It's not just wrapping,
it's clarify the logical behavior.
