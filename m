Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B77C4360C
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Mar 2021 21:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 741EB64F34
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Mar 2021 21:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378979AbhCBVo1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 2 Mar 2021 16:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449003AbhCBQDc (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 2 Mar 2021 11:03:32 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1399BC06178C
        for <linux-sgx@vger.kernel.org>; Tue,  2 Mar 2021 08:02:21 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id e6so14092713pgk.5
        for <linux-sgx@vger.kernel.org>; Tue, 02 Mar 2021 08:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=svOHLaBnqkDfLhE0cZ4LJEE36nGBqyQ9USTfjmqqgrQ=;
        b=Lt+J5F4Qzn5XcdVTLUz5v5KhazZ3GtoSKi4eCwnhUyfDVP7CjIdTe7wrEupIgJjMIA
         HlEZVtJ4zbOe7b76HD6dAnG1S4mTkKoSoRXAJchNJGjm5jbrHl2vNE2e9zX2776arIOf
         UdKsWBRwTk9ywichOZb2Ro3wb2a2Z+VxipxSFch75SK8FHkGV246bAofC+niKQpJXehf
         72HdOj0vU8M5ay2vJJwK40EHtP0D4bsWr/cHZQsOdFTq+DzNSkk9AJFiElG6TSAEPQtk
         W/sjo/MiPdD35E2LyD3d1O6fbxO62upDmumlXFe+R2chC97vx6mTl3qzaOix0UNu7QPy
         uqmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=svOHLaBnqkDfLhE0cZ4LJEE36nGBqyQ9USTfjmqqgrQ=;
        b=TTAiiqIvsTHqRi5OMB0J8pUYl35zIn1nubNkH3M3d+vg4IBmiGBtVUCyZPox1LkhIc
         JCjfOycGkiCcgj9vRtNtUACyw0G89nG+GwXSuLuFajw0YJdYEWtrlOBzz2+vAz2EzeGV
         pzVjhROJqWJ9vg+enSjR8CatkuKtVk8IxDfZSmD+C1cB+YH1Ie1rj1UJu3i0l1g55NWf
         n5MfDXfJR7p+d3lQqKYy7BSmPRapfYRLw6jQeereRY6obp4H67pOGol3lJjJ8P40BRhq
         arPnu0Se/1HwR263dZ2sxVvN/0SUOJytEDWg42h9p7u+g1Pd3K1YkRvtfl9r+EzJQFaj
         H5Vg==
X-Gm-Message-State: AOAM531/73UgGvGo6p+5pvlMB+GZ8fsfnx2QTWqRpuZtiGCAjdPuyU1N
        81p2uN4h/cQMXBueQpBunJ1nrA==
X-Google-Smtp-Source: ABdhPJw8fIoq/1KmCJqNQp/hD/uLuk0oH7QC1JQ5gpW5sqU026irp8qx8M6uJ7zNiZLj0GP87RUJYw==
X-Received: by 2002:a62:7d17:0:b029:1ee:3bbe:fa5f with SMTP id y23-20020a627d170000b02901ee3bbefa5fmr3727106pfc.67.1614700940422;
        Tue, 02 Mar 2021 08:02:20 -0800 (PST)
Received: from google.com ([2620:15c:f:10:805d:6324:3372:6183])
        by smtp.gmail.com with ESMTPSA id ie12sm3763220pjb.52.2021.03.02.08.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 08:02:19 -0800 (PST)
Date:   Tue, 2 Mar 2021 08:02:13 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH 02/25] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Message-ID: <YD5hhah9Sgj1YGqw@google.com>
References: <cover.1614590788.git.kai.huang@intel.com>
 <bbfc8c833a62e4b55220834320829df1e17aff41.1614590788.git.kai.huang@intel.com>
 <20210301100037.GA6699@zn.tnic>
 <3fce1dd2abd42597bde7ae9496bde7b9596b2797.camel@intel.com>
 <20210301103043.GB6699@zn.tnic>
 <7603ef673997b6674f785d333a4f263c749d2cf3.camel@intel.com>
 <20210301105346.GC6699@zn.tnic>
 <e509c6c1e3644861edafb18e4045b813f9f344b3.camel@intel.com>
 <20210301113257.GD6699@zn.tnic>
 <0adc41774945bf9d6e6a72a93b83c80aa8c59544.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0adc41774945bf9d6e6a72a93b83c80aa8c59544.camel@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 02, 2021, Kai Huang wrote:
> On Mon, 2021-03-01 at 12:32 +0100, Borislav Petkov wrote:
> > On Tue, Mar 02, 2021 at 12:28:27AM +1300, Kai Huang wrote:
> > > I think some script can utilize /proc/cpuinfo. For instance, admin can have
> > > automation tool/script to deploy enclave (with sgx2) apps, and that script can check
> > > whether platform supports sgx2 or not, before it can deploy those enclave apps. Or
> > > enclave author may just want to check /proc/cpuinfo to know whether the machine can
> > > be used for testing sgx2 enclave or not.
> > 
> > This doesn't sound like a concrete use of this. So you can hide it
> > initially with "" until you guys have a use case. Exposing it later is
> > always easy vs exposing it now and then not being able to change it
> > anymore.
> > 
> 
> Hi Haitao, Jarkko,
> 
> Do you have more concrete use case of needing "sgx2" in /proc/cpuinfo?

The KVM use case is to query /proc/cpuinfo to see if sgx2 can be enabled in a
guest.

The counter-argument to that is we might want sgx2 in /proc/cpuinfo to mean sgx2
is enabled in hardware _and_ supported by the kernel.  Userspace can grep for
sgx in /proc/cpuinfo, and use cpuid to discover sgx2, so it's not a blocker.

That being said, adding some form of capability/versioning to SGX seems
inevitable, not sure it's worth witholding sgx2 from /proc/cpuinfo.
