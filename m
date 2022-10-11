Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91DCDC433FE
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Oct 2022 14:04:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiJKOEp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 11 Oct 2022 10:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiJKOEo (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 11 Oct 2022 10:04:44 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B971261B
        for <linux-sgx@vger.kernel.org>; Tue, 11 Oct 2022 07:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665497080; x=1697033080;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sAIuAySQrImvpxDrqRyZyVQhmA8VYkWDXCwXG/Qfs/k=;
  b=IxuvkPBoy3oOTwfds2FwOvpuA6AvY4S0kPLzg2h0wD/JCi+MaDz7dWwe
   F/gRM/qD5dyd05qVJ9qE6xWHk1AiQ0zFOtvnpLLUNkz0IBnlvAEKpjQ1L
   hn6yCUBEzJfXXtx55/jYWQJq2M0AF1951HDWeJzSZjPvej8MV71goV39U
   ZjxlNCl3WGmENGe75SIhas7j6miaQ+KC9wpojlvpUlRRIou+hUFo3SgLE
   3ZRW6l3pp/Y2EkEy4G1tJi5qzMZjH2777eHS/2MGY/juzMXgtrEqv5LS3
   6MzZB6KsjdocaMudIszQG99SGI7+gQ1GM6aE/redjrQOqYruKvbLpx1HO
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10497"; a="330991977"
X-IronPort-AV: E=Sophos;i="5.95,176,1661842800"; 
   d="scan'208";a="330991977"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2022 07:04:15 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10497"; a="577445568"
X-IronPort-AV: E=Sophos;i="5.95,176,1661842800"; 
   d="scan'208";a="577445568"
Received: from makozuch-mobl2.amr.corp.intel.com (HELO [10.209.39.67]) ([10.209.39.67])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2022 07:04:14 -0700
Message-ID: <b775a187-32ad-836f-557f-3486ef4ac8dd@intel.com>
Date:   Tue, 11 Oct 2022 07:04:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Content-Language: en-US
To:     Zhiquan Li <zhiquan1.li@intel.com>, linux-sgx@vger.kernel.org,
        tony.luck@intel.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        kai.huang@intel.com
Cc:     seanjc@google.com, fan.du@intel.com, cathy.zhang@intel.com
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
 <20220920063948.3556917-4-zhiquan1.li@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20220920063948.3556917-4-zhiquan1.li@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 9/19/22 23:39, Zhiquan Li wrote:
> Today, if a guest accesses an SGX EPC page with memory failure,
> the kernel behavior will kill the entire guest.  This blast
> radius is too large.  It would be idea to kill only the SGX

				ideal ^

> application inside the guest.
> 
> To fix this, send a SIGBUS to host userspace (like QEMU) which can
> follow up by injecting a #MC to the guest.

This doesn't make any sense to me.  It's *ALREADY* sending a SIGBUS.
So, whatever is making this better, it's not "send a SIGBUS" that's
doing it.

What does this patch actually do to reduce the blast radius?

> SGX virtual EPC driver doesn't explicitly prevent virtual EPC instance
> being shared by multiple VMs via fork().  However KVM doesn't support
> running a VM across multiple mm structures, and the de facto userspace
> hypervisor (Qemu) doesn't use fork() to create a new VM, so in practice
> this should not happen.

This is out of the blue.  Why is this here?

What happens if a hypervisor *DOES* fork()?  What's the fallout?
