Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E235C4332F
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Oct 2022 15:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiJMPpf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Oct 2022 11:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiJMPpd (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 13 Oct 2022 11:45:33 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C5165679
        for <linux-sgx@vger.kernel.org>; Thu, 13 Oct 2022 08:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665675932; x=1697211932;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oigiYGGuZaUvckY6PnxUSVuuGsQZHKmCHlkjnEmsDB4=;
  b=fp5MW6TZRZ5Pco4Ur2BSkjaGtbr8Tk55hodw23/3jq5v5VkEkgyq7/PS
   1PpoYH9BMoybjRnzW+U1UAtPkIIuU86ILdAMp6FVTHVv1N+ysMyVNcU3O
   zamBiH7Xa5do5GdM3uPSB/oUJ6CaQdp//p6ND4nKMtvHuGOBqpoz+1zlh
   t+gdh6ip527lzTH3yT41J4Uxl0PDCoVdQU3oGTRRsM1dNJTiy83ELi/SB
   PKmKP7/kCfurkz+qH2sNr/ihr7nR624OmykfMvAUQ9Kc/7DtOwmLPyQn+
   3EvZPj4QVhu7rghnnvuMyGmN11h4UdeUln/GvdnTHuMA/b6Xx3Rm/ced5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="305105347"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="305105347"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 08:44:51 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="956215592"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="956215592"
Received: from mkucejko-mobl.ger.corp.intel.com (HELO [10.213.24.166]) ([10.213.24.166])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 08:44:45 -0700
Message-ID: <fc9ed3e0-94f1-0bbc-06db-fd14d41b7c21@intel.com>
Date:   Thu, 13 Oct 2022 08:44:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Content-Language: en-US
To:     Zhiquan Li <zhiquan1.li@intel.com>, linux-sgx@vger.kernel.org,
        tony.luck@intel.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com, kai.huang@intel.com
Cc:     seanjc@google.com, fan.du@intel.com, cathy.zhang@intel.com,
        bp@suse.de, tglx@linutronix.de
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
 <20220920063948.3556917-4-zhiquan1.li@intel.com>
 <b775a187-32ad-836f-557f-3486ef4ac8dd@intel.com>
 <14fabc80-a9fc-05b4-eda1-62f2b265e66b@intel.com>
 <f8b49a6b-44ce-9477-b2ba-39abadfbd68f@intel.com>
 <fb885d7f-388c-6a53-798b-06805fefca3d@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <fb885d7f-388c-6a53-798b-06805fefca3d@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 10/13/22 07:40, Zhiquan Li wrote:
>>>> What happens if a hypervisor *DOES* fork()?  What's the fallout?
>>> This part originates from below discussion:
>>>
>>> https://lore.kernel.org/linux-sgx/52dc7f50b68c99cecb9e1c3383d9c6d88734cd67.camel@intel.com/#t
>>>
>>> It intents to answer the question:
>>>
>>>     Do you think the processes sharing the same enclave need to be
>>>     killed, even they had not touched the EPC page with hardware error?
>>>
>>> Dave, do you mean it's not appropriate to be put here?
>> It's actually a pretty important point, but it's still out of the blue.
>>
>> You also didn't answer my question.
> Oh, sorry, I focused on answering "Why is this here?" but forgot to
> answer "What's the fallout?"
> 
> It's a very good question.
> 
> Looks like Kai had answered it before:
> 
> 	For instance, an application can open /dev/sgx_vepc, mmap(), and
> 	fork().  Then if the child does mmap() against the fd opened by
> 	the parent, the child will share the same vepc with the parent.
> 
> 	...
> 
> 	Sharing virtual EPC instance will very likely unexpectedly break
> 	enclaves in all VMs.

How, though?  This basically says, "I think things will break."  I want
to know a few more specifics than that before we merge this.  There are
ABI implications.

> https://lore.kernel.org/linux-sgx/52dc7f50b68c99cecb9e1c3383d9c6d88734cd67.camel@intel.com/#t
> 
> Moreover, I checked the code in below scenario while child sharing the
> virtual EPC instance with parent:
> - child closes /dev/sgx_vepc earlier than parent.
> - child re-mmap() /dev/sgx_vepc to the same memory region as parent.
> - child mmap() /dev/sgx_vepc to different memory region.
> - child accesses the memory region of mmap() inherited from parent.
> 
> It's just that the app messes itself up, the vepc instance is protected
> very well.
> Maybe there are other corner cases I've not considered?

... and what happens when *THIS* patch is in play?  What if there is a
machine check in SGX memory?
