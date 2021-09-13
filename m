Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFA0FC433F5
	for <linux-sgx@archiver.kernel.org>; Mon, 13 Sep 2021 21:11:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C09060FC1
	for <linux-sgx@archiver.kernel.org>; Mon, 13 Sep 2021 21:11:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243318AbhIMVNM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 13 Sep 2021 17:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbhIMVNM (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 13 Sep 2021 17:13:12 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47BF3C061760
        for <linux-sgx@vger.kernel.org>; Mon, 13 Sep 2021 14:11:56 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id w6so6709059pll.3
        for <linux-sgx@vger.kernel.org>; Mon, 13 Sep 2021 14:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XlbYYs1xpz35Iv85qYFjd2jgM/KVGCtGbcbWYfPgCP4=;
        b=rDor+CBYfNx9Srb9QxGYupt6qFScu9pnfYePIyjV+REzi8u/TLSom19+QJI+GEYZGS
         IK3c+VRyjTMO4Gpfzq5MJdHp55oLiukyf1EoYJTZ/JQYxNZ5WpBzPiANszDPEGQzXQHX
         uMPW6UC5k83YmImCyVEXRQr4NtxjysuwJsMg5xP7+EVxfjAg5ssfhetNp4yWET/v5XX+
         uPyQwgmoyKuppK+a/t3bCcTQDfe/x3x9ilGCtpSz0ZpGIQBooEBlYDwSwlrdl6ng9k42
         JJfACUYOxL/Xgv6L5//YEXw+uNxExk6Ckbd17k/3OCK0KEycQjd6Fm4+EuFknWWCuRoc
         EgXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XlbYYs1xpz35Iv85qYFjd2jgM/KVGCtGbcbWYfPgCP4=;
        b=RYNvwqWyYhxz3wKfoKCmqB2XZt8Z+fpeCLxUmNj8sC6QGgnAdD+/0m3AxizPELk/6U
         F09we2lF7UoChJjAfcg7KXXWlYC5aHm5ScItikplHmsxEhp2Kh0kp8mIt45MlhMAwaKO
         GsdecPMAKyVEimS6lX1uQ7RCnvi9APdnBVb46n8AzYJwTYLIOqco0xPNPJKh8JHmmAbr
         /D9mO9gOJClRM2VQRgfPjOaqyb1DFQBeWxuZO9CVG4SVvOUieahi71lzeFruRumvPeCC
         9h3l1JCTAfCVsxwMwy1Lm7rg0aB9+eJoHNl5crsdS5YcZCSoMxZ0t/SIci4cs87rrvDq
         1XrQ==
X-Gm-Message-State: AOAM532k3jhAIqDmRAKS/UaGijQNkfwZUurzo4P7tz12u/NPOymevmtx
        uIhUW00lvt8y1JStDRt0oG6KmQ==
X-Google-Smtp-Source: ABdhPJyDPbwAccoS6lshuqcQMWi6uDYAndD0nTMcsAQem30TsztdgQMDMlrNMjsvJBIKqI3xqCNkMg==
X-Received: by 2002:a17:90a:db17:: with SMTP id g23mr1541721pjv.193.1631567515587;
        Mon, 13 Sep 2021 14:11:55 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id gw21sm7499946pjb.36.2021.09.13.14.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 14:11:55 -0700 (PDT)
Date:   Mon, 13 Sep 2021 21:11:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        jarkko@kernel.org, dave.hansen@linux.intel.com,
        yang.zhong@intel.com
Subject: Re: [PATCH 2/2] x86: sgx_vepc: implement SGX_IOC_VEPC_REMOVE ioctl
Message-ID: <YT++l/gSpx3FPMKL@google.com>
References: <20210913131153.1202354-1-pbonzini@redhat.com>
 <20210913131153.1202354-3-pbonzini@redhat.com>
 <50287173-0afb-36f4-058e-0960fb4017a7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50287173-0afb-36f4-058e-0960fb4017a7@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 13, 2021, Dave Hansen wrote:
> On 9/13/21 6:11 AM, Paolo Bonzini wrote:
> > +static long sgx_vepc_remove_all(struct sgx_vepc *vepc)
> > +{
> > +	struct sgx_epc_page *entry;
> > +	unsigned long index;
> > +	long failures = 0;
> > +
> > +	xa_for_each(&vepc->page_array, index, entry)
> > +		if (sgx_vepc_remove_page(entry))
> > +			failures++;
> > +
> > +	/*
> > +	 * Return the number of pages that failed to be removed, so
> > +	 * userspace knows that there are still SECS pages lying
> > +	 * around.
> > +	 */
> > +	return failures;
> > +}
> 
> I'm not sure the retry logic should be in userspace.  Also, is this
> strictly limited to SECS pages?  It could also happen if there were
> enclaves running that used the page.  Granted, userspace can probably
> stop all the vcpus, but the *interface* doesn't prevent it being called
> like that.

The general rule for KVM is that so long as userspace abuse of running vCPUs (or
other concurrent operations) doesn't put the kernel/platform at risk, it's
userspace's responsibility to not screw up.  The main argument being that there
are myriad ways the VMM can DoS the guest without having to abuse an ioctl().

> What else can userspace do but:
> 
> 	ret = ioctl(fd, SGX_IOC_VEPC_REMOVE);
> 	if (ret)
> 		ret = ioctl(fd, SGX_IOC_VEPC_REMOVE);
> 	if (ret)
> 		printf("uh oh\n");
> 
> We already have existing code to gather up the pages that couldn't be
> EREMOVE'd and selectively EREMOVE them again.  Why not reuse that code
> here?  If there is 100GB of EPC, it's gotta be painful to run through
> the ->page_array twice when once plus a small list iteration will do.

My argument against handling this fully in the kernel is that to handle a vNUMA
setup with multiple vEPC sections, the ioctl() would need to a take a set of file
descriptors to handle the case where an SECS is pinned by a child page in a
diferent vEPC.  It would also require an extra list_head per page (or dynamic
allocations), as the list_head in sgx_epc_page will (likely, eventually) be needed
to handle EPC OOM.  In the teardown case, sgx_epc_page.list can be used because
the pages are taken off the active/allocated list as part of teardown.

Neither issue is the end of the world, but IMO it's not worth burning the memory
and taking on extra complexity in the kernel for a relatively rare operation that's
slow as dirt anyways.

> Which reminds me...  Do we need a cond_resched() in there or anything?
> That loop could theoretically get really, really long.
