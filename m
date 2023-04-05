Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF0F3C7619A
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Apr 2023 12:36:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238047AbjDEMgu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 5 Apr 2023 08:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238043AbjDEMgt (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 5 Apr 2023 08:36:49 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E681F3ABD
        for <linux-sgx@vger.kernel.org>; Wed,  5 Apr 2023 05:36:47 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-5002f12ccfeso43448a12.0
        for <linux-sgx@vger.kernel.org>; Wed, 05 Apr 2023 05:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1680698206; x=1683290206;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E6iWx9EB6J3L8iIop1bmZ+pNlziIEisMA1uL8RnykGc=;
        b=Mhpu4CDBYYy7UnbecnwaJGBwUWEJJZkdvrEefXyX2r+r4FENpB1qkR+tX4rIEcLLNc
         HUVfqZlrktiiC1UivQlXrKHRQSwPD9fmbGSjOmWfxRDbCoEgopYVA0XuQ3TzQrDsGHl8
         V/sMzxOY9dAQhT6ShYmtLicdzfCt+/18NkPTo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680698206; x=1683290206;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E6iWx9EB6J3L8iIop1bmZ+pNlziIEisMA1uL8RnykGc=;
        b=vFzwQoWlReCXlgcQ0aR7mfuWtwxLNYqgh46gfeFjfxRz0+wEHiOCN1LcMC/wb3DAps
         DnyegKfsfehMKitglPtssiKG1/24tsgXuOxNuJTT1XiWU1sUl0TpYr60KU9MCefsJOND
         i4zIQ1sq1GzImR+qpYf5BFiOcP6i4jTvXE88GUQz3rV40fzopztUDenUYIEWf0ENln2b
         uvfbq4TWYIq72+3FqH/d8LffZdgy65IZ8hq8UGAsK6bSzsdNidzZIeyYdec/pGYxRgPf
         X2uCWxh0grAaxaeI8AqY96CUORPk6QHEfvXL/YapRf6cfg11dT+KfrUXDPXLsC7VF/Ui
         ElHA==
X-Gm-Message-State: AAQBX9fmKc6YtATEXhRr3lQzEpiuV68X7l7ofqGzZmGluY6v+uLhv2Iw
        9vWivtM9HHQAojsfsrFmoYNZUw==
X-Google-Smtp-Source: AKy350YIBJGEKIbnfG5Qb41ZqY8oW3SBwxFUxtFvD5haG8Sd7EjZxbYnmEZUvlkuPcFwlyaw2lVQPg==
X-Received: by 2002:a05:6402:d0e:b0:502:e50:3358 with SMTP id eb14-20020a0564020d0e00b005020e503358mr1779099edb.3.1680698206345;
        Wed, 05 Apr 2023 05:36:46 -0700 (PDT)
Received: from phenom.ffwll.local (212-51-149-33.fiber7.init7.net. [212.51.149.33])
        by smtp.gmail.com with ESMTPSA id q16-20020a50aa90000000b004af6c5f1805sm7265301edc.52.2023.04.05.05.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 05:36:45 -0700 (PDT)
Date:   Wed, 5 Apr 2023 14:36:43 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     Asahi Lina <lina@asahilina.net>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>,
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
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH RFC 04/18] rust: drm: gem: Add GEM object abstraction
Message-ID: <ZC1rW+ZktoC9fBaX@phenom.ffwll.local>
Mail-Followup-To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Asahi Lina <lina@asahilina.net>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>, Miguel Ojeda <ojeda@kernel.org>,
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
        linux-sgx@vger.kernel.org, asahi@lists.linux.dev
References: <20230307-rust-drm-v1-0-917ff5bc80a8@asahilina.net>
 <20230307-rust-drm-v1-4-917ff5bc80a8@asahilina.net>
 <ZC1WwJDr1iqSQnYs@phenom.ffwll.local>
 <CANiq72=h9qKrpkY2K962__rs-JLsmWxPXocx040ZeDSKGf_Brw@mail.gmail.com>
 <ZC1aEZpgZLkq8xTv@phenom.ffwll.local>
 <CANiq72=hoVw566orbDYcJyw2+SFfxpR1rdJVbbR3kkrjJUASww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72=hoVw566orbDYcJyw2+SFfxpR1rdJVbbR3kkrjJUASww@mail.gmail.com>
X-Operating-System: Linux phenom 6.1.0-7-amd64 
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Apr 05, 2023 at 02:32:12PM +0200, Miguel Ojeda wrote:
> On Wed, Apr 5, 2023 at 1:23 PM Daniel Vetter <daniel@ffwll.ch> wrote:
> >
> > Ok if this is just interim I think it's fine. Would still be good to have
> > the MAINTAINERS entry though even just to cover the interim state. Least
> > because I'm assuming that when things are split up you'd still want to
> > keep the rust list on cc for the rust parts, even when they move into
> > subsystems?
> 
> Sorry, I missed to reply the second part of your email -- replying here.
> 
> Currently, the subsystem's code is under `rust/` (though modules can
> go already into other folders). One of the reasons was technical
> simplicity, and a nice side effect is that we could bootstrap things
> while getting C maintainers involved over time.
> 
> To accomplish that, the guidelines for contributing Rust code are that
> the respective maintainers need to be at least Cc'd, even if the files
> do not hit the `F:` fields for the time being -- see [1]. But, for us,
> ideally, the maintainers will take the changes through their tree,
> instead of going through the Rust one, since that is the end goal.
> 
> And, of course, if you already want to have `F:` fields for the Rust
> code, that is even better! (Whether those should be in the same entry
> or in a new one, it is up to you, of course, and whether it is a
> different set of people / level of support / etc.)
> 
> Then, when the `kernel` crate split happens, we can move the code
> directly under whatever folders it should be naturally, when their
> maintainers are ready. For some subsystems, that may mean they do not
> need any `F:` fields since they are already covered (e.g. if they did
> not create a new entry for Rust code only). And for cases like yours,
> where you already had `F:` fields, it means the move of the files can
> be done right away as soon as the split happens.
> 
> In short, we would definitely welcome if you add `F:` fields already
> (whether in existing or new entries) -- it would mean you are ahead of
> the curve! :)
> 
> As for the mailing list, yes, for the time being, I ask that all
> changes to please be sent to the Rust list, so that everybody that
> wants to follow the Rust progress has everything in a single place, so
> that we try to remain consistent in the beginning on e.g. coding
> guidelines, so that Rust reviewers can help spot mistakes, and so on
> and so forth.
> 
> But, as Rust grows in the kernel, as systems become non-experimental,
> and as maintainers take ownership of the code, that should eventually
> go away and let things be as usual with C code. Then the Rust
> subsystem (and its list) will become smaller, and it will be the
> subsystem (and the discussion place) for anything not covered by other
> subsystems, such as core Rust abstractions and types, Rust
> infrastructure and so on.
> 
> How does that sound?

Yeah sounds all great!

I think interim at least a separate rust drm entry
would be good, to make sure we always cc both rust and dri-devel. Once
it's too much for you and you generally trust the dri-devel folks to not
design stupid interfaces, we can then drop that and only ping rust folks
when needed. I do expect that's some years out though.
-Daniel

> 
> [1] https://rust-for-linux.com/contributing#the-rust-subsystem (I may
> reorganize this to be Rust's `P:` field, by the way)
> 
> Cheers,
> Miguel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
