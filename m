Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38DF4C4332F
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Nov 2022 16:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiKDQ0T (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 4 Nov 2022 12:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiKDQ0R (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 4 Nov 2022 12:26:17 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04BF1C402
        for <linux-sgx@vger.kernel.org>; Fri,  4 Nov 2022 09:26:16 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id l2so5320332pld.13
        for <linux-sgx@vger.kernel.org>; Fri, 04 Nov 2022 09:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6SyzdgnxaMPnepwRBYvqPj7otA2s8/q/A5GnrnGxkh4=;
        b=V4DEjqI2s/ZjwMN7p1tegDPTYnl7288Ps3Be12TmIdZ2CrCTJMaexz1UdGRdNKfvJI
         f3m1NI2hFZeqDCRn82fHFNV3mft49DrveO3ObtjgSFA2/13KMpzU6DHUqsKYzaV1Ofxq
         bxhOAFuB3x8w8TEEyFcUtTe7MzYgZHab9wTRA3SuqpZwG48t40xmHW7w8x6uLIBM6nUv
         hXOt5EOSM+bmlP+/UFOGpNiToC62gaGWc1DaF6ibhz3LubudJr8pOqEz6/puQ/8tk/cc
         0lZKzQm8ejf+YIop4+Rx4AsxTNl2/mhqvRe1jb8pfRa69724z1kwkfOVlffwSUysgauo
         h0Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6SyzdgnxaMPnepwRBYvqPj7otA2s8/q/A5GnrnGxkh4=;
        b=EJpU0f2Av9VXtEOqjqMBH097PAeemSVZyyBb3iiU5+d/C2ccY5VqijZ4OcQnf06tfC
         HTwsmvmr51uptOI4i/PuMLY6W3AFjedTIIDYwX5yjZoN3zhuoKn5UKxL3UtkygBk2Vfu
         x/fv3EvmFi/M+WpCWcgwNO5k1hZYO6jZUkUGMLaUlaN0zzGRP5F2cC/UGyCN0qvXMMpy
         G9tc7EyT5bsUTYQ7ldjSWYv4RbxvhFgrAOOhYUQhsj0xei+CP47S9fV235nw+XchMatB
         zn55ZcRndheyTdopXv+4BEYXsPObcSYEm0eCdazKyn4lLMIScYTefB+Y9MxIxhPYXKFU
         1p3g==
X-Gm-Message-State: ACrzQf0mJmfTPUIPfRosBHT7EMXOO+vW4uL0Dri23HZcblJKrTf4gs0c
        yd5VSN6ykYs8sRk3lAipKSQUdw==
X-Google-Smtp-Source: AMsMyM4KS1L2RM5tiFiy7QrAYBbFply4NFbtU9nCdnzE4mmHP5Tx/ptbyeLvlGZcVv1i6D4t/cAKhQ==
X-Received: by 2002:a17:902:e750:b0:186:de24:bbe3 with SMTP id p16-20020a170902e75000b00186de24bbe3mr35628139plf.51.1667579176221;
        Fri, 04 Nov 2022 09:26:16 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f132-20020a62388a000000b0056da8c41bbasm2913336pfa.161.2022.11.04.09.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 09:26:15 -0700 (PDT)
Date:   Fri, 4 Nov 2022 16:26:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "Li, Zhiquan1" <zhiquan1.li@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bp@suse.de" <bp@suse.de>, "Zhang, Cathy" <cathy.zhang@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>, "Du, Fan" <fan.du@intel.com>
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Message-ID: <Y2U9JJUBFiscIidn@google.com>
References: <5ade54ce8e182307309426e1055dcc580c1dc5fc.camel@intel.com>
 <4930999a-888f-88bc-a05c-86762504f059@intel.com>
 <c8e7cff6f8d66ce4f8575caaf69f02b491ed7d90.camel@intel.com>
 <5afff147-dfb4-9033-6826-5965ba0bf3a0@intel.com>
 <061580727e503d092ca3867919fa0f26391568eb.camel@intel.com>
 <10c4b928a37fdf96df767fc7b8f1348f6af05984.camel@intel.com>
 <Y1WmZgqIkl8GkR/i@kernel.org>
 <e8f1e391-0362-33b7-aaf6-45a685eba0a4@intel.com>
 <Y2BsSCM1BWlsqPcK@kernel.org>
 <65924f603f88462eae6edd5ecb9f56aec1be1864.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65924f603f88462eae6edd5ecb9f56aec1be1864.camel@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Nov 04, 2022, Huang, Kai wrote:
> > > In fact, to share a virtual EPC instance in userspace doesn't make any
> > > sense.  Even though it can be shared by child, the virtual EPC page
> > > cannot be used by child correctly.
> > 
> > OK, makes sense, thanks for the explanation!
> > 
> > Why would we want to enforce for user space not to do this, even
> > if it does cause malfunctioning program?
> > 
> > BR, Jarkko
> 
> Hi Jarkko, Dave,
> 
> I've been re-thinking about this #MC handle on virtual EPC by stepping back to
> the beginning, and I think we have more problems than this "whether kernel
> should enforce child cannot mmap() virtual EPC".

IMO, virtual EPC should be restricted to a single mm_struct, which is what was
originally proposed many years ago[*].  I should have pushed back harder, but by
that point I had mostly stopped caring about SGX.

There is no use case for sharing a virtual EPC, and conceptually it just doesn't
make sense because all use would need to be mutually exclusive on a per-page basis
to keep the EPCM happy.

[*] https://lore.kernel.org/kvm/ace9d4cb10318370f6145aaced0cfa73dda36477.1609890536.git.kai.huang@intel.com

> First of all, if we want to use epc->owner to carry the userspace virtual
> address, "make kernel enforce child cannot mmap() virtual EPC" alone isn't good
> enough -- nothing prevents userspace to call mmap() several times to map the
> same virtual EPC pages.  So additionally, we also need to "make kernel enforce
> one virtual EPC can only be mmap()-ed once".
> 
> Secondly, I am thinking that the current arch_memory_failure() cannot really
> handle #MC for virtual EPC page correctly.  The problem is, even we mark the
> page as poisoned, and send signal to userspace to inject #MC to guest to handle,
> the poisoned virtual EPC page is never unmapped from the guest and then freed.
> 
> This means a malicious guest can always try to use the poisoned EPC page again
> after it receives #MC on some EPC page.  I am not entirely sure what kind
> behaviour/attack can be done in such case, but it seems the right behaviour
> should be the KVM to inject the #MC and unmap the poisoned EPC page from guest.
> And if guest ever tries to use this "guest's EPC page" (GFN) again, KVM should
> kill the guest.

Just zap the PTEs for the affected mm_struct, mmu_notifier => KVM will do the rest.
