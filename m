Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8802C4332F
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Oct 2022 11:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiJLLyV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 12 Oct 2022 07:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiJLLyU (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 12 Oct 2022 07:54:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A6BB2771
        for <linux-sgx@vger.kernel.org>; Wed, 12 Oct 2022 04:54:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 41C27CE1B49
        for <linux-sgx@vger.kernel.org>; Wed, 12 Oct 2022 11:54:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2325C433C1;
        Wed, 12 Oct 2022 11:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665575653;
        bh=Q158Tbh8UOlKfepVxQIMlXAGwvQT8dD0CRuRaDvndaQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aDsu5IdZeS0jccdz1zIGi9BVN4I7ZkDhRG3ffjblp9BENnJTT5W5qy32C7VjnnFF4
         MZ2D4bfYgiuSPf6WhwNlKzd/vNn9C2wZh8duhxj6BpIthU9L4aBaAZE2QofMh3gXHl
         XMRnUwow2CGWvVt72BfQH8hURxLA+koeTI28OuBbfCG1GT7DI8CsN3fCMBwUsWZxgT
         Juja/LX4LQKyxJodgg66zPI/lT2Vi9TTBBW1XZbsgBneZjwuQ80ZqJebYu7ybhe9AK
         F2kW5Len5RiHt876k+q8Is3PiCffB3T6MfkgaYgzQWjoQbVeEcu6u6jiB3toXkjQM+
         JciORUd0QYUsQ==
Date:   Wed, 12 Oct 2022 14:54:09 +0300
From:   "jarkko@kernel.org" <jarkko@kernel.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Li, Zhiquan1" <zhiquan1.li@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Du, Fan" <fan.du@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>, "bp@suse.de" <bp@suse.de>
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Message-ID: <Y0aq4azJwL8G8OKv@kernel.org>
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
 <20220920063948.3556917-4-zhiquan1.li@intel.com>
 <b775a187-32ad-836f-557f-3486ef4ac8dd@intel.com>
 <14fabc80-a9fc-05b4-eda1-62f2b265e66b@intel.com>
 <188a334629319e430e16d4caf5e4a421b80c357a.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <188a334629319e430e16d4caf5e4a421b80c357a.camel@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 12, 2022 at 11:01:49AM +0000, Huang, Kai wrote:
> On Wed, 2022-10-12 at 13:09 +0800, Zhiquan Li wrote:
> > > > SGX virtual EPC driver doesn't explicitly prevent virtual EPC instance
> > > > being shared by multiple VMs via fork().  However KVM doesn't support
> > > > running a VM across multiple mm structures, and the de facto userspace
> > > > hypervisor (Qemu) doesn't use fork() to create a new VM, so in practice
> > > > this should not happen.
> > > 
> > > This is out of the blue.  Why is this here?
> > > 
> > > What happens if a hypervisor *DOES* fork()?  What's the fallout?
> > 
> > This part originates from below discussion:
> > 
> > https://lore.kernel.org/linux-sgx/52dc7f50b68c99cecb9e1c3383d9c6d88734cd67.camel@intel.com/#t
> > 
> > It intents to answer the question:
> > 
> >     Do you think the processes sharing the same enclave need to be
> >     killed, even they had not touched the EPC page with hardware error?
> 
> Sharing virtual EPC instance will very likely unexpectedly break enclaves in all
> VMs.  Whether kernel should explicitly prevent is another topic. To me I don't
> see strong reason to enforce in the kernel.  For instance, multiple VMs can map
> the same file as memory backend with MAP_SHARED, in which case they can all
> break.  Userspace should use virtual EPC in the right way.

Broadly speaking, for most of the time, and for any topic, kernel should
not prevent anything, unless it can break kernel's internal state.

> But the point is above is not directly related to your patch.  On host where
> multiple processes can share one enclave legally, it does the same thing.  I
> think you can just remove that paragraph from changelog.
> 
> -- 
> Thanks,
> -Kai
> 
> 

BR, Jarkko
