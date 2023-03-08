Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE51C64EC4
	for <linux-sgx@archiver.kernel.org>; Wed,  8 Mar 2023 17:49:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjCHRtC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 8 Mar 2023 12:49:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjCHRtB (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 8 Mar 2023 12:49:01 -0500
X-Greylist: delayed 589 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 08 Mar 2023 09:49:00 PST
Received: from out-52.mta1.migadu.com (out-52.mta1.migadu.com [95.215.58.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30CAB6A9C9
        for <linux-sgx@vger.kernel.org>; Wed,  8 Mar 2023 09:48:59 -0800 (PST)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rosenzweig.io;
        s=key1; t=1678297145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yVSYNjCHn8PZygOPU8FaPpzcyZxyRzar8PA59R3WlkM=;
        b=FTUuASPVjKjYV3cgR8DM7Q/D53G17nSjTRtKK5kslyagyxeCTRYYVbKDtQhi9bpH3m+ZtA
        9oHrB3kWjYVdDTETA/SNEJKa+eU8UFpHExrxk++MTgaVzb52a+0ybd1dQYV8QRbztzU9V+
        ECi9YEUuH0+actMuPHGLiHa8Nqk0iOEjLbQziYOK2/+ZeN0xmLqR5tzoikyb0lhhoSQkWg
        MrrwH48EDj11rAURsP9leymAeja4qCI04DgkljR/dqQVtrW1AmhzYa7ASmzRTyBiDLw1I4
        RwWVNA6leYb6hAGM5PLKb5yoArBe2XIqoLIl8Bp+mc3Qg4H9hlAbvAOC4/tHiw==
Date:   Wed, 08 Mar 2023 17:39:03 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   alyssa@rosenzweig.io
Message-ID: <8e93126cfaf47ebad0dc70e038ccc92f@rosenzweig.io>
Subject: Re: [PATCH RFC 11/18] drm/scheduler: Clean up jobs when the
 scheduler is torn down
To:     "Asahi Lina" <lina@asahilina.net>,
        "=?utf-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?=" <christian.koenig@amd.com>,
        "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>,
        "Maxime Ripard" <mripard@kernel.org>,
        "Thomas Zimmermann" <tzimmermann@suse.de>,
        "David Airlie" <airlied@gmail.com>,
        "Daniel Vetter" <daniel@ffwll.ch>,
        "Miguel Ojeda" <ojeda@kernel.org>,
        "Alex Gaynor" <alex.gaynor@gmail.com>,
        "Wedson Almeida Filho" <wedsonaf@gmail.com>,
        "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
        "=?utf-8?B?QmrDtnJuIFJveSBCYXJvbg==?=" <bjorn3_gh@protonmail.com>,
        "Sumit Semwal" <sumit.semwal@linaro.org>,
        "Luben Tuikov" <luben.tuikov@amd.com>,
        "Jarkko Sakkinen" <jarkko@kernel.org>,
        "Dave Hansen" <dave.hansen@linux.intel.com>
Cc:     "Karol Herbst" <kherbst@redhat.com>,
        "Ella Stanforth" <ella@iglunix.org>,
        "Faith Ekstrand" <faith.ekstrand@collabora.com>,
        "Mary" <mary@mary.zone>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, rust-for-linux@vger.kernel.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        linux-sgx@vger.kernel.org, asahi@lists.linux.dev
In-Reply-To: <0f14c1ae-0c39-106c-9563-7c1c672154c0@asahilina.net>
References: <0f14c1ae-0c39-106c-9563-7c1c672154c0@asahilina.net>
 <20230307-rust-drm-v1-0-917ff5bc80a8@asahilina.net>
 <20230307-rust-drm-v1-11-917ff5bc80a8@asahilina.net>
 <bbd7c5ee-c2f0-3e19-757d-a9aff1a26d3d@linux.intel.com>
 <585fa052-4eff-940e-b307-2415c315686a@amd.com>
 <3320e497-09c0-6eb6-84c5-bab2e63f28ec@asahilina.net>
 <7b39ef96-3ec5-c492-6e1b-bf065b7c90a2@amd.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> You can't ask me for a list=0A> of pending jobs (the scheduler knows th=
is, it doesn't make any sense to=0A> duplicate that outside)=0A=0ASilly q=
uestion: could you add a new exported function to drm_sched to get the li=
st of pending jobs, to be used by the Rust abstraction internally? IDK if=
 that makes any sense.
