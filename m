Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E35DC433FE
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Oct 2022 22:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiJMW3E (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Oct 2022 18:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJMW3D (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 13 Oct 2022 18:29:03 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC355194FB5
        for <linux-sgx@vger.kernel.org>; Thu, 13 Oct 2022 15:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665700142; x=1697236142;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Nd/bgGxrNh5yfj16WKo+837S+c53uiYRr3+gmiVxR94=;
  b=atgkQ/sB91pJbeW+RjCy+7LRQqGPCCx5pE6cy9r1pNeYE4FMsaa1EqNZ
   5iJFsENnodE0GxGTyNkabdJZ3adEprTAXmSNBKOD3USaWjvXZItSqasWF
   /BB+jSVLmzfZ7+f4IGARXgVFAh9rUwRX8bbhf9eOwPjNr0lQl9p/5yVet
   kh2+fQgKscA2u08yofCyXQ+fCThZMa3f7z1EdfWaC7lRN/UX5SbprWYrP
   J6h7jpM6wPFhtEJseLBpAOBseTV8Bkdh6IuKLYDNxdjJkRPzpMIrYpGrq
   TBxq2QzBN2B0Gpv4yTPBVbMdsyovez8U4i830MC7PbddrFu/BCwAXkPc9
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="284947579"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="284947579"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 15:29:02 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="752696469"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="752696469"
Received: from mkucejko-mobl.ger.corp.intel.com (HELO [10.213.24.166]) ([10.213.24.166])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 15:28:55 -0700
Message-ID: <4930999a-888f-88bc-a05c-86762504f059@intel.com>
Date:   Thu, 13 Oct 2022 15:28:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Li, Zhiquan1" <zhiquan1.li@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Cc:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "Du, Fan" <fan.du@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>, "bp@suse.de" <bp@suse.de>
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
 <20220920063948.3556917-4-zhiquan1.li@intel.com>
 <b775a187-32ad-836f-557f-3486ef4ac8dd@intel.com>
 <14fabc80-a9fc-05b4-eda1-62f2b265e66b@intel.com>
 <f8b49a6b-44ce-9477-b2ba-39abadfbd68f@intel.com>
 <fb885d7f-388c-6a53-798b-06805fefca3d@intel.com>
 <fc9ed3e0-94f1-0bbc-06db-fd14d41b7c21@intel.com>
 <42470b9c41adefd2d4b4c79a3b7b2963cd24f423.camel@intel.com>
 <4f82ec46-4c85-babb-38ea-a6ecc5e397a9@intel.com>
 <5ade54ce8e182307309426e1055dcc580c1dc5fc.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <5ade54ce8e182307309426e1055dcc580c1dc5fc.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 10/13/22 15:15, Huang, Kai wrote:
> On Thu, 2022-10-13 at 15:02 -0700, Hansen, Dave wrote:
>> Specifically, with this machine check SIGBUS implementation, one EPC
>> page can only have on host virtual address.  But, it's possible to
>> mmap() a single VEPC page in multiple processes at multiple host virtual
>> addresses.
>>
>> So, the implementation only allows one host virtual address.  But, we
>> can imagine a scenario where there are *TWO* valid virtual addresses
>> where the VEPC is mapped.
>>
>> What might happen in this case?  What's the fallout?
> 
> My understanding is there can be two #MC happening on two virtual addresses.
> 
> Each #MC will be injected to the VM which triggers that #MC to handle.

OK but which address with each of them see in siginfo->si_addr?  There's
only one ->vepc_vaddr.

It seems to me like this might result in the siginfo getting populated
with the ->si_addr from the *OTHER* process and *OTHER* virtual address.
 Basically, whoever allocates the page sets up *their* virtual address.
 Anyone else who gets a machine check on that page will see a virtual
address that has nothing to do with its virtual address space.

Is that problematic?
