Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32B19C7618D
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Apr 2023 11:27:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237323AbjDFL1H (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 6 Apr 2023 07:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235777AbjDFL1G (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 6 Apr 2023 07:27:06 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303161FE7
        for <linux-sgx@vger.kernel.org>; Thu,  6 Apr 2023 04:27:04 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-502aa0f24daso126882a12.1
        for <linux-sgx@vger.kernel.org>; Thu, 06 Apr 2023 04:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1680780422;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kAw/L7Dpu+b4V/xTQbdmukEYxphyameFjwcA8l9wSDg=;
        b=fHznqF7eG0vW5uKwPQTw3TEorgKpPJ44tWqMMS1bLZ8rioYwh7YDjGNxggq2rQvCZ7
         PbYvtRYuNsql5s87NsBOLtpy0e59OGQtXTGQvCdPIFc+azXSxjy/OLskHoTa5IkreieM
         FS1QTRK4LC/0xWp87GMiqXMdQRh1CRUD50XRo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680780422;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kAw/L7Dpu+b4V/xTQbdmukEYxphyameFjwcA8l9wSDg=;
        b=ToaKvA6GO818/harPBdzYjZc8Z114oSawWHFgZzpQg3tEvMzWyxNtSC1XP8KNcE1Hz
         PDRfO4iUmbmHPXjfIZrAuXzaKmdBRpH8D7+T5muRQO2IlnzMRp8oXsolJU7rSiNcI/43
         q//EVMPW2R/0cmPxv+KA5sUmWB1Xxf7KNQiuykqlgvq43RV+3kjvWzujzeBiKfr0gL6f
         PoN6pMVBX/qAjQzCuT+a3G40D9wMf3rqDl7EEJ8MaEDNicvaPCjYSTvBcFZUHBxNETmW
         e2TIHkWk5iRq+9YDRqM/A6jNPWZ6Td0xF3WbIeRno26/RisJ3uJsf2G7GR0c3p9wVjF9
         b9Tw==
X-Gm-Message-State: AAQBX9eRtox8LhLskR1E5pT4tGaKwVkguj6nuz6GHxbBeIUPblvN8xcA
        UmXDKuvuRyQiq0ZD/aE5VNr1WA==
X-Google-Smtp-Source: AKy350bptijxOtOZSpadNvp+R7+33XZwiCa/nVw1qp46SFOgNKauNT/gV1Qtm6GB1bmElAsuJbDFCg==
X-Received: by 2002:a17:906:208a:b0:947:bff2:1c2b with SMTP id 10-20020a170906208a00b00947bff21c2bmr4207639ejq.1.1680780422562;
        Thu, 06 Apr 2023 04:27:02 -0700 (PDT)
Received: from phenom.ffwll.local (212-51-149-33.fiber7.init7.net. [212.51.149.33])
        by smtp.gmail.com with ESMTPSA id n5-20020a170906840500b0093fa8c2e877sm687738ejx.80.2023.04.06.04.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 04:27:02 -0700 (PDT)
Date:   Thu, 6 Apr 2023 13:26:59 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Asahi Lina <lina@asahilina.net>
Cc:     Daniel Vetter <daniel@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Miguel Ojeda <ojeda@kernel.org>,
        Alex Gaynor <alex.gaynor@gmail.com>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
        =?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Luben Tuikov <luben.tuikov@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Karol Herbst <kherbst@redhat.com>,
        Ella Stanforth <ella@iglunix.org>,
        Faith Ekstrand <faith.ekstrand@collabora.com>,
        Mary <mary@mary.zone>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, rust-for-linux@vger.kernel.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        linux-sgx@vger.kernel.org, asahi@lists.linux.dev,
        David Airlie <airlied@gmail.com>
Subject: Re: [PATCH RFC 18/18] drm/asahi: Add the Asahi driver for Apple AGX
 GPUs
Message-ID: <ZC6sgxnPaQTnApmI@phenom.ffwll.local>
Mail-Followup-To: Asahi Lina <lina@asahilina.net>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Miguel Ojeda <ojeda@kernel.org>,
        Alex Gaynor <alex.gaynor@gmail.com>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
        =?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Luben Tuikov <luben.tuikov@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Karol Herbst <kherbst@redhat.com>,
        Ella Stanforth <ella@iglunix.org>,
        Faith Ekstrand <faith.ekstrand@collabora.com>,
        Mary <mary@mary.zone>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, rust-for-linux@vger.kernel.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        linux-sgx@vger.kernel.org, asahi@lists.linux.dev,
        David Airlie <airlied@gmail.com>
References: <20230307-rust-drm-v1-0-917ff5bc80a8@asahilina.net>
 <20230307-rust-drm-v1-18-917ff5bc80a8@asahilina.net>
 <ZC2HtBOaoUAzVCVH@phenom.ffwll.local>
 <8d28f1d3-14b0-78c5-aa16-e81e2a8a3685@asahilina.net>
 <6c7b9a98-bcd0-29e6-af72-a2fcae10148c@asahilina.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c7b9a98-bcd0-29e6-af72-a2fcae10148c@asahilina.net>
X-Operating-System: Linux phenom 6.1.0-7-amd64 
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Apr 06, 2023 at 02:09:21PM +0900, Asahi Lina wrote:
> Argh. This (and my other reply) was supposed to go to Daniel, but
> Thunderbird... just dropped that recipient? And then my silly brain saw all
> the Cc:s go to To: and figured it was some weird consolidation and so I
> moved everything to Cc: except the only name that started with "Da" and...
> yeah, that wasn't the same person.
> 
> Sorry for the confusion... I have no idea why Thunderbird hates Daniel...

Don't worry, I get cc'ed on so much stuff that whether I'm cc'ed or not
has zero impact on whether I'll read a mail or not. It just kinda
disappears into the big lable:cc bucket ...
-Daniel

> 
> On 06/04/2023 13.44, Asahi Lina wrote:
> > On 05/04/2023 23.37, Daniel Vetter wrote:
> > > On Tue, Mar 07, 2023 at 11:25:43PM +0900, Asahi Lina wrote:
> > > > +/// A generic monotonically incrementing ID used to uniquely identify object instances within the
> > > > +/// driver.
> > > > +pub(crate) struct ID(AtomicU64);
> > > > +
> > > > +impl ID {
> > > > +    /// Create a new ID counter with a given value.
> > > > +    fn new(val: u64) -> ID {
> > > > +        ID(AtomicU64::new(val))
> > > > +    }
> > > > +
> > > > +    /// Fetch the next unique ID.
> > > > +    pub(crate) fn next(&self) -> u64 {
> > > > +        self.0.fetch_add(1, Ordering::Relaxed)
> > > > +    }
> > > > +}
> > > 
> > > Continuing the theme of me commenting on individual things, I stumbled
> > > over this because I noticed that there's a lot of id based lookups where I
> > > don't expect them, and started chasing.
> > > 
> > > - For ids use xarray, not atomic counters. Yes I know dma_fence timelines
> > >     gets this wrong, this goes back to an innocent time where we didn't
> > >     allocate more than one timeline per engine, and no one fixed it since
> > >     then. Yes u64 should be big enough for everyone :-/
> > > 
> > > - Attaching ID spaces to drm_device is also not great. drm is full of
> > >     these mistakes. Much better if their per drm_file and so private to each
> > >     client.
> > > 
> > > - They shouldn't be used for anything else than uapi id -> kernel object
> > >     lookup at the beginning of ioctl code, and nowhere else. At least from
> > >     skimming it seems like these are used all over the driver codebase,
> > >     which does freak me out. At least on the C side that's a clear indicator
> > >     for a refcount/lockin/data structure model that's not thought out at
> > >     all.
> > > 
> > > What's going on here, what do I miss?
> > 
> > These aren't UAPI IDs, they are driver-internal IDs (the UAPI IDs do use
> > xarray and are per-File). Most of them are just for debugging, so that
> > when I enable full debug spam I have some way to correlate different
> > things that are happening together (this subset of interleaved log lines
> > relate to the same submission). Basically just object names that are
> > easier to read (and less of a security leak) than pointers and
> > guaranteed not to repeat. You could get rid of most of them and it
> > wouldn't affect the driver design, it just makes it very hard to see
> > what's going on with debug logs ^^;
> > 
> > There are only two that are ever used for non-debugging purposes: the VM
> > ID, and the File ID. Both are per-device global IDs attached to the VMs
> > (not the UAPI VM objects, but rather the underlyng MMU address space
> > managers they represent, including the kernel-internal ones) and to
> > Files themselves. They are used for destroying GEM objects: since the
> > objects are also device-global across multiple clients, I need a way to
> > do things like "clean up all mappings for this File" or "clean up all
> > mappings for this VM". There's an annoying circular reference between
> > GEM objects and their mappings, which is why this is explicitly coded
> > out in destroy paths instead of naturally happening via Drop semantics
> > (without that cleanup code, the circular reference leaks it).
> > 
> > So e.g. when a File does a GEM close or explicitly asks for all mappings
> > of an object to be removed, it goes out to the (possibly shared) GEM
> > object and tells it to drop all mappings marked as owned by that unique
> > File ID. When an explicit "unmap all in VM" op happens, it asks the GEM
> > object to drop all mappings for that underlying VM ID. Similarly, when a
> > UAPI VM object is dropped (in the Drop impl, so both explicitly and when
> > the whole File/xarray is dropped and such), that does an explicit unmap
> > of a special dummy object it owns which would otherwise leak since it is
> > not tracked as a GEM object owned by that File and therefore not handled
> > by GEM closing. And again along the same lines, the allocators in
> > alloc.rs explicitly destroy the mappings for their backing GEM objects
> > on Drop. All this is due to that annoying circular reference between VMs
> > and GEM objects that I'm not sure how to fix.
> > 
> > Note that if I *don't* do this (or forget to do it somewhere) the
> > consequence is just that we leak memory, and if you try to destroy the
> > wrong IDs somehow the worst that can happen is you unmap things you
> > shouldn't and fault the GPU (or, in the kernel or kernel-managed user VM
> > cases, potentially the firmware). Rust safety guarantees still keep
> > things from going entirely off the rails within the kernel, since
> > everything that matters is reference counted (which is why these
> > reference cycles are possible at all).
> > 
> > This all started when I was looking at the panfrost driver for
> > reference. It does the same thing except it uses actual pointers to the
> > owning entities instead of IDs, and pointer comparison (see
> > panfrost_gem_close). Of course you could try do that in Rust too
> > (literally storing and comparing raw pointers that aren't owned
> > references), but then you're introducing a Pin<> requirement on those
> > objects to make their addresses stable and it feels way more icky and
> > error-prone than unique IDs (since addresses can be reused). panfrost
> > only has a single mmu (what I call the raw VM) per File while I have an
> > arbitrary number, which is why I end up with the extra
> > distinction/complexity of both File and VM IDs, but the concept is the same.
> > 
> > Some of this is going to be refactored when I implement arbitrary VM
> > range mapping/unmapping, which would be a good time to improve this...
> > but is there something particularly wrong/broken about the way I'm doing
> > it now that I missed? I figured unique u64 IDs would be a pretty safe
> > way to identify entities and cleanup the mappings when needed.
> > 
> > ~~ Lina
> > 
> 
> ~~ Lina
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
