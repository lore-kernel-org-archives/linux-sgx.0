Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9545AEB64D7
	for <linux-sgx@archiver.kernel.org>; Wed, 28 Jun 2023 14:57:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbjF1O5d (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 28 Jun 2023 10:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjF1O5a (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 28 Jun 2023 10:57:30 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACA5198D
        for <linux-sgx@vger.kernel.org>; Wed, 28 Jun 2023 07:57:29 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-55b2ac94f31so524598a12.2
        for <linux-sgx@vger.kernel.org>; Wed, 28 Jun 2023 07:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687964249; x=1690556249;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b4Hk6SZxMckvPXzeHaOGrwu2P5WvJg1tLd1OslXColA=;
        b=fz1NRjiduugFwo6YuWRtGU5+HZOXr1pO2GjmeKe19Qckb8T4n8T737LyWIyjCmeYNk
         mMib1Sh7i1PeiGIgR1zCXVcZMV+DZgXffWMh8DhUYdJG7yGREMOqqeK+TSxWzcnrmLQ0
         h52YLw+B3T6jLmDBLbNksK0r2w7qSfqprV8ZSuqdKzSeibyzeNYkiSAqnf/RI2ff2Q36
         UXLlLjgk0zgroV6hhfBAs8E3cBFk8qrdmQNIM1NjSXDn+t+U9weR0xtTk1Ws3NBBSv0T
         WBUB30VRFeTWrNQJZCRRrBV99p2kgn13y8wvfH9/QDxA+aIGWxPtZGkwGClDgOw1gqSP
         /ERA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687964249; x=1690556249;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=b4Hk6SZxMckvPXzeHaOGrwu2P5WvJg1tLd1OslXColA=;
        b=lpKYdtuXszEkAySloqhYgc32ShKpmNaNXF+n4M9puOSqzR9Dm/tCt0GqyywJs1i4iD
         atarINIyZpZZm4Cby5fJRk0keFQRFbDkdBDRGDftDQieLAmA+lLY/fGhMkpWkXkoPvmA
         dEdPN1Js9gCToDck8cHC6tBlrbqA8VwwiR1zpRi1zWwozGavzaN2IaOJGS+xvyXU/9V0
         ONof4nQ/J/sdNsy3RDLami8iKJGMlScZ1R3fMYwq34irww5YlxsuDRtbTi92Jwz/Ww+K
         fOfPDoAO3JZcDWXkqAEPbN6wZcuIoCokbwgp1u9seFS0pEvw83gN3ErjrLFNCq/EOuqe
         rIMw==
X-Gm-Message-State: AC+VfDzeteCFV4JVf1NTwLqkgu39OgcHYJsYuqsXK52NJq/COEXFHunN
        5S+bFiWKKdKjHFMhJg3o44RgbfUWRsY=
X-Google-Smtp-Source: ACHHUZ5C0uRa2UJ2c19ncVzFrjrV1WMfXv62Yvjuop77kKkiCJsE6uJvDOBmiHMepUCs9InaYRGZrryEvRA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:43c2:0:b0:53f:f4ca:1b0 with SMTP id
 q185-20020a6343c2000000b0053ff4ca01b0mr4380473pga.9.1687964249142; Wed, 28
 Jun 2023 07:57:29 -0700 (PDT)
Date:   Wed, 28 Jun 2023 07:57:27 -0700
In-Reply-To: <1a980d3ce2caec1cf44bf97d52fa08fbe72e741f.camel@intel.com>
Mime-Version: 1.0
References: <5930de9d076d148ae572aa081c7dee8a5b696b61.camel@intel.com>
 <d0b65bbdd20a79a43d979b08972dd05bfc79b08c.camel@intel.com>
 <ZIzcrmU1RA7oEeQ7@google.com> <fc214963a01ca975d6de2991b63c93f04114c562.camel@intel.com>
 <ZJTEpH2yYtHmTRWr@google.com> <66f22efc5a920a805d6863dcc152c3c12e8fb6fb.camel@intel.com>
 <ZJoRHU1CHxIuDH29@google.com> <7e78ec8fd22ad9f8b828fa00b9811bbfcf855b2c.camel@intel.com>
 <ZJr3PthzDgugKDcO@google.com> <1a980d3ce2caec1cf44bf97d52fa08fbe72e741f.camel@intel.com>
Message-ID: <ZJxKV1/2M+OeIXAN@google.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Reinette Chatre <reinette.chatre@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 28, 2023, Kai Huang wrote:
> On Tue, 2023-06-27 at 07:50 -0700, Sean Christopherson wrote:
> > The question that you really want to ask is "could change XYZ break
> > userspace?"
>=20
> Agreed.
>=20
> But since "encl->has_mismatched_offsets" is sort of new ABI, I think we n=
eed to
> be careful otherwise in the future we may hit this kinda nasty issue agai=
n.
>=20
> Here's my thoughts:
>=20
> (Again, let's forget about mmap(/dev/sgx_enclave) to reserve ELRANGE for =
now.)
>=20
> 1) Current ABI is SGX driver _ignores_ pgoff for mmap(/dev/sgx_enclave)s

Yes.

> (but requires MAP_FIXED).

No, SGX doesn't require MAP_FIXED.  The requirements of ELRANGE make it ext=
remely
unlikely that mmap() will succeed, but it's not a strict requirement.=20

> 2) Therefore,=EF=BF=BD"passing the correct pgoff" in new userspace app do=
esn't break the
> current ABI.  If the new app chooses to pass the correct pgoff, it will w=
ork.

Yep.

> 3) With additional support of sgx_fadvice(WILLNEED) within the driver, th=
e new
> app can use madvice(WILLNEED) if it passes the correct pgoff when mmap().=
  If
> wrong pgoff is passed, then madvice(WILLNEED) will work unexpectedly and =
could
> result in enclave being killed.  It's userspace app's responsibility to m=
ake
> sure the correctness, not the driver's.

Hmm, yeah, it's probably ok to lean on documentation if userspace screws up=
.  I
generally prefer explicit errors over "undefined behavior", but I don't hav=
e a
super strong opinion, especially since this isn't my area these days :-)=20

> 4) Old SGX apps which don't use file-based ABIs and still pass 0 pgoff sh=
ould
> continue to work.  No break of old apps either.

Yep.
=20
> 5) We encourage new apps to always pass the correct pgoff instead of pass=
ing 0.
>=20
> 6) If needed, we can modify sgx_mmap() to relax the needing to use MAP_FI=
XED,
> but return the enclave's address "based on pgoff from userspace".

As above, this isn't a relaxation of anything since MAP_FIXED isn't strictl=
y
required, it's simply additional functionality.

> This effectively provides additional mmap() ABI for userspace while not
> breaking the existing MAP_FIXED ABI.

I don't think you want to do this.  The MAP_FIXED case won't be affected, b=
ut the
address provided to mmap() is also used as a hint in the !MAP_FIXED case,, =
i.e.
MAP_FIXED just means use *exactly* this address and don't try anything else=
.  It's
unlikely, but not _that_ unlikely, that there are userspace applications th=
at
specify the exact address without MAP_FIXED and without the correct pgoff.

If there were more to gain by steering mmap() based solely on pgoff, then i=
t might
be worth trying, but this doesn't seem to provide much value to userspace s=
ince
the virtual address of any given enclave mapping is mission critical, e.g. =
it seems
unlikely that userspace wouldn't already know the virtual address it needs.
