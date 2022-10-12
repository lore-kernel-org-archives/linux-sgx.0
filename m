Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EA1CC4332F
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Oct 2022 14:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiJLOgH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 12 Oct 2022 10:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiJLOgG (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 12 Oct 2022 10:36:06 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F47F1E70D
        for <linux-sgx@vger.kernel.org>; Wed, 12 Oct 2022 07:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665585365; x=1697121365;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mmv6YfvgWVLkYjTBM5vy7tRaFCtR69pHS0lcYjPChvw=;
  b=CWOT5czl13Ri42wtg2nb0/tshyxIiJwRTINaJsgGhLn3nfV2UnAxmq5p
   sep1TqvlogjyPbyK7PQGYb0PBADF3mt3HAUu6IA1rcjqWB4xORBZC7TEG
   E7URa6hOxoey1hlyJbu+o6y6ITTeCwI6iWET2cnmoenHlwcP25poiBJTJ
   I1YBkek5HibZfkhtK8ztTAnaFlktc6iq7M+qKBrJaYULLi4dhSvEJ0C6D
   iJukoyCn0PG7+TVqYpaADIH9tphTWu9smSKCmwI4p1w/p8qi+CCO56+UX
   DJwBBmq9EtktT9YKPoZkx9zVHa3/jUjMt1Wys2GCY2AkI4LsEU5Rylmw6
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10497"; a="331302442"
X-IronPort-AV: E=Sophos;i="5.95,179,1661842800"; 
   d="scan'208";a="331302442"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2022 07:36:04 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10497"; a="715941200"
X-IronPort-AV: E=Sophos;i="5.95,179,1661842800"; 
   d="scan'208";a="715941200"
Received: from mpatter1-mobl.amr.corp.intel.com (HELO [10.209.53.34]) ([10.209.53.34])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2022 07:36:03 -0700
Message-ID: <f8b49a6b-44ce-9477-b2ba-39abadfbd68f@intel.com>
Date:   Wed, 12 Oct 2022 07:36:03 -0700
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
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <14fabc80-a9fc-05b4-eda1-62f2b265e66b@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 10/11/22 22:09, Zhiquan Li wrote:
>>> application inside the guest.
>>>
>>> To fix this, send a SIGBUS to host userspace (like QEMU) which can
>>> follow up by injecting a #MC to the guest.
>>
>> This doesn't make any sense to me.  It's *ALREADY* sending a SIGBUS.
>> So, whatever is making this better, it's not "send a SIGBUS" that's
>> doing it.
>>
>> What does this patch actually do to reduce the blast radius?
> 
> Thanks for your attention, Dave.
> 
> This part comes from your comments previously:
> 
> https://lore.kernel.org/linux-sgx/Yrf27fugD7lkyaek@kernel.org/T/#m6d62670eb530fab178eefaaaf31a22c4475e818d
> 
> The key is the SIGBUS should with code BUS_MCEERR_AR and virtual address
> of virtual EPC page. Hypervisor can identify it with the specific code
> and inject #MC to the guest.
> 
> Can we change the statement like this?
> 
>     To fix this, send a SIGBUS with code BUS_MCEERR_AR and virtual
>     address of virtual EPC page to host userspace (like QEMU) which can
>     follow up by injecting a #MC to the guest.

This is really just mechanically restating what the patch does.  It
doesn't help me understand how it achieves the goal.  I guess I'll just
go and write the changelog for you.  Here's what I was missing:

	There is already a signal-based ABI to tell userspace about
	machine checks.  But, SGX does not use that ABI.  Today, the
	kernel delivers a generic SIGBUS if a machine check occurs when
	accessing SGX memory.  Userspace can not differentiate that
	SIGBUS from <add example here>, so it is very unlikely to be
	able to recover from the signal and the app will die.

	To fix this, have the SGX machine check code generate a SIGBUS
	which leverages the existing BUS_MCEERR_AR ABI.  This enlightens
	userspace about why the SIGBUS was generated and gives it a
	chance of being able to handle the signal.

	QEMU, for instance, has code to handle these BUS_MCEERR_AR
	signals today.  Without this patch, QEMU will just die in the
	face of a generic SIGBUS, and take the whole VM with it.  With
	this patch <explain what QEMU actually does here>.

	In short, BUS_MCEERR_AR enables QEMU to reduce the blast radius
	down from the whole QEMU process to a single page.

This patch doesn't *actually* reduce the blast radius.  It enables QEMU
to do that.

>>> SGX virtual EPC driver doesn't explicitly prevent virtual EPC instance
>>> being shared by multiple VMs via fork().  However KVM doesn't support
>>> running a VM across multiple mm structures, and the de facto userspace
>>> hypervisor (Qemu) doesn't use fork() to create a new VM, so in practice
>>> this should not happen.
>>
>> This is out of the blue.  Why is this here?
>>
>> What happens if a hypervisor *DOES* fork()?  What's the fallout?
> 
> This part originates from below discussion:
> 
> https://lore.kernel.org/linux-sgx/52dc7f50b68c99cecb9e1c3383d9c6d88734cd67.camel@intel.com/#t
> 
> It intents to answer the question:
> 
>     Do you think the processes sharing the same enclave need to be
>     killed, even they had not touched the EPC page with hardware error?
> 
> Dave, do you mean it's not appropriate to be put here?

It's actually a pretty important point, but it's still out of the blue.

You also didn't answer my question.
