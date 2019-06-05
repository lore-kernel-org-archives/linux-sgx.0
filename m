Return-Path: <SRS0=6XgF=UE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C3EC28CC5
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Jun 2019 20:00:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C21B1207E0
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Jun 2019 20:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559764834;
	bh=9XdBy9z3phbIJjul8o84TBc6gUxrJN3UJwM7mUvx3mY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=gwVjZixQoz6hxbDAGa+V/Ahq9km+2kW+ErBeqsdvrSWGPcu1i5ofL4qnCy00dQs/G
	 KxzomXBZcN+klDI8ZMXfB0xw/1MFa601CgnLNKL5bu6Qc1mdTD6yQfljNEYzYs/yK/
	 OKBmldA6RQ3SCmLgx3N6zfXYSGw6CetnOdN10h/E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfFEUAe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 5 Jun 2019 16:00:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbfFEUAd (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 5 Jun 2019 16:00:33 -0400
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3A0020874
        for <linux-sgx@vger.kernel.org>; Wed,  5 Jun 2019 20:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559764832;
        bh=9XdBy9z3phbIJjul8o84TBc6gUxrJN3UJwM7mUvx3mY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gV7mldGLTd/FWji7eNB9NFJiGwfgabROiB4fmgBUsZ+m7gfT4lxYEunmqcJ62QsPp
         nFUeGIp2AJuAZxpWSZBItmoTzgShv6ncemLyal6utOJZJRvV1lhX31H1KA4z589Zen
         HaBiMKJWC4OeuKAr6FUuOWAUAmKiHBtfmIsHT5Y0=
Received: by mail-wm1-f44.google.com with SMTP id v19so101741wmj.5
        for <linux-sgx@vger.kernel.org>; Wed, 05 Jun 2019 13:00:32 -0700 (PDT)
X-Gm-Message-State: APjAAAUsvHeSP1X/M7rFJhQcUdTmHRySWvU60OpMBsV4OKyb2OvYYL5l
        T5rT0qCPBpVOO1XZRRJAOC+RNslIvF5g8RQcyLplvQ==
X-Google-Smtp-Source: APXvYqzi4fVtOkR7NrCpUDLTVSJarydUXPIBCnc3nFgclqYBAk1YVgdfb8zbTpr7Kwqf3JpJo6mVS1KdlYMov2Kv7bs=
X-Received: by 2002:a1c:6242:: with SMTP id w63mr20376277wmb.161.1559764831199;
 Wed, 05 Jun 2019 13:00:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190605194845.926-1-sean.j.christopherson@intel.com>
 <20190605194845.926-8-sean.j.christopherson@intel.com> <726c5b53-acd9-49c0-d4f6-b7a3aefb264c@intel.com>
In-Reply-To: <726c5b53-acd9-49c0-d4f6-b7a3aefb264c@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Wed, 5 Jun 2019 13:00:20 -0700
X-Gmail-Original-Message-ID: <CALCETrV2Fj-XWYZE2ZYj87O1hCEgXM3uhBLy4kD=e0PZT_aYyQ@mail.gmail.com>
Message-ID: <CALCETrV2Fj-XWYZE2ZYj87O1hCEgXM3uhBLy4kD=e0PZT_aYyQ@mail.gmail.com>
Subject: Re: [PATCH 7/7] x86/sgx: Add a reserved field to sgx_enclave_add_region
 to drop 'packed'
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org, Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 5, 2019 at 12:59 PM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 6/5/19 12:48 PM, Sean Christopherson wrote:
> >  struct sgx_enclave_add_region {
> >       __u64   addr;
> > @@ -51,7 +52,8 @@ struct sgx_enclave_add_region {
> >       __u64   secinfo;
> >       __u32   flags;
> >       __u16   mrmask;
> > -} __attribute__((__packed__));
> > +     __u16   reserved;
> > +};
>
> Without __packed__ do we have strong enough guarantees from the compiler
> for a stable ABI?

We rely on this kind of thing for uapi on a regular basis, so I sure hope so.
