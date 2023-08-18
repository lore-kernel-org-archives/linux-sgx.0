Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E363CC7112B
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Aug 2023 08:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358474AbjHRINC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 18 Aug 2023 04:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358470AbjHRIMh (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 18 Aug 2023 04:12:37 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C682D68
        for <linux-sgx@vger.kernel.org>; Fri, 18 Aug 2023 01:12:35 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-52564f3faf7so729172a12.1
        for <linux-sgx@vger.kernel.org>; Fri, 18 Aug 2023 01:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1692346354; x=1692951154;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3ExkJNHrMqkD14TVRbSwRbYGo1SL2hauVrLeSxqeyoQ=;
        b=aAihkKdyAKeoynjpo66+cshaO87Hp0ENkknoe6i4nJ5txGgH/10VHmoZKcf/1Xi9Bg
         LNNY9oxLnyrZ4kQ0GP6IJcbNotWu/eXY1rZBP9wFMZYEKIKmh3aZtyw/nytC5Cq6tuwa
         JvD/OVN3pbjNuYyM8BH5Tamm4hcy8sq6/DPixlmKY+QweXYsOXxHXG2zlfTCtkan1Iv6
         ebLW8Ty8Hg1U6w7Yf0m7HX0edmoInTQQ8g27mbzCMSRqtq1La4XPG6fdH59p4UVunrA1
         NLDlOLUE/OV91qSRTysO8Bp9tQzH3OfAiNn+lZi2aQk0LVoQKKKcE1U7mJxZuO9PURiB
         T/dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692346354; x=1692951154;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3ExkJNHrMqkD14TVRbSwRbYGo1SL2hauVrLeSxqeyoQ=;
        b=DTmp3hgN/vBIRkwL7H3MSXJvVRoFMkGcs4lNz15ub6jo+pBXel/bBcL46d8m+ltrY+
         ptU7l4kFCDGWeaXmmNh2gLK73jBO5pDybHUiRwzk02DUJ0L/0H0xvLpIAG6SEqTJ5uZl
         Z3uGHuEJTN9FBe0K09kf1i41nM7OBDv+NOqFNB91Xs0D0xa7FGnuEqaIDWcF72+HCfX1
         +Py9lj3dwc1XGe4NIpw9W87avE67lmAcr42Q9iE4/+kyFVGsllGKT//lDWnTBLq5l7K1
         cxmu836TnCpltRBvrxNTFj76L3sdHS1p1RIFuzYxxJ9p/4sxGuSfsm7T/wm+woneJW/v
         p+uw==
X-Gm-Message-State: AOJu0YyhkXgqLKIOHWLho2yPC4hQfXr9u6bjlvcBZfLO9m0N5hnbO8C4
        OM5oxHeSy+RqAvcdGuyzdeKXRdQ6PWYEa6M6584bvc/2MHAyHFj+
X-Google-Smtp-Source: AGHT+IErGB1NcoKtPbHWzx+qVnuVSPZ1XMMUdjRuBv5WoG12O4DVCTsbTe9Oa3CUlhLRaJr50a+EXnkb4qL4T9Js5XE=
X-Received: by 2002:aa7:da53:0:b0:522:cb97:f196 with SMTP id
 w19-20020aa7da53000000b00522cb97f196mr1857782eds.36.1692346354162; Fri, 18
 Aug 2023 01:12:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230814043714.107971-1-jinpu.wang@ionos.com> <3954697abb1a6c84c4b30fbd0d5edcafae6f6966.camel@intel.com>
 <CAMGffEk_ojyRsMy_7d1R0aacwNQ0itDV+ZYTDH0Fpoy03iPkTg@mail.gmail.com>
 <3061b0ccb3a61b856498ebfc27d400250fa550c6.camel@intel.com> <CUUY2LHIXLJO.2C4M4O5Q3SVCD@seitikki>
In-Reply-To: <CUUY2LHIXLJO.2C4M4O5Q3SVCD@seitikki>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Fri, 18 Aug 2023 10:12:23 +0200
Message-ID: <CAMGffE=q8gMqrQSpwUuRjz_jTTDdOBti6pcDp20PFKszTM74MA@mail.gmail.com>
Subject: Re: [PATCH] x86/sgx: Avoid softlockup from sgx_vepc_release
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "yu.zhang@ionos.com" <yu.zhang@ionos.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 17, 2023 at 6:02=E2=80=AFPM Jarkko Sakkinen <jarkko@kernel.org>=
 wrote:
>
> On Thu Aug 17, 2023 at 10:00 AM UTC, Huang, Kai wrote:
> > On Thu, 2023-08-17 at 09:38 +0200, Jinpu Wang wrote:
> > > > This adds cond_resched() to the first two loops: releasing non-SECS=
 pages and
> > > > releasing SECS pages which don't have children on remote vepc insta=
nce(s).
> > > > There is a third round loop to release SECS pages which have childr=
en on remote
> > > > vepc instance(s).  I think it's better to add cond_resched() there =
too, although
> > > > it's extremely unlikely it could trigger softlockup w/o cond_resche=
d().
> > >
> > > I also think the third one are extremely unlikely could cause softloc=
kup.
> > > And our tests do not hit it either.
> >
> > If we only consider your tests, then I believe you even don't need the =
second
> > cond_resched()?
> >
> > I think we should just add cond_resched() to all the three loops.  No h=
arm, and
> > we don't need to worry about this anymore.
>
> I'm fine with this.

Ok, as both of you think it's better to cover all 3 cases. I will do
it in v3 later today.
>
> BR, Jarkko
Thx!
