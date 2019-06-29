Return-Path: <SRS0=WPzH=U4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46282C4321A
	for <linux-sgx@archiver.kernel.org>; Sat, 29 Jun 2019 01:22:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7105208E3
	for <linux-sgx@archiver.kernel.org>; Sat, 29 Jun 2019 01:22:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DLClEsA6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfF2BWS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 28 Jun 2019 21:22:18 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:41603 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbfF2BWS (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 28 Jun 2019 21:22:18 -0400
Received: by mail-io1-f65.google.com with SMTP id w25so16318087ioc.8;
        Fri, 28 Jun 2019 18:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=p/YRxjFdEYymkpmzeXrnxJ8jP4xFlWlIPqeqDi2I3jQ=;
        b=DLClEsA6t9hW4nTq9Vcf9G0aPKV5CVhdrXgam0wqA7hVAT7QgDK0j0j/0/iSN6+2x8
         wAMb06BaB4q0UvPaq49Yzcpca6FklAseijg3WtjgC/LEMgHBzjRwL/gmU/UwoUBRDcoA
         AN5nLq9tYUpZ1vpLlM43/Lh5K78pii+V4ZtT9lK/MSfZVY45xjGBE4otAXFh3KfSm52U
         I/+WqjbEqnxA6Km590YL2NGzvLV2Uei6vldGQlB1L2sJhsJX7pja277Ydp2Mb58+j72N
         zJ77Bc9U3Qs2E0hcUxla9ySRNohAjM1NlDWjlfBUPe6CvKZpwlhKLiDRLHS6yyJWyZjg
         DaFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=p/YRxjFdEYymkpmzeXrnxJ8jP4xFlWlIPqeqDi2I3jQ=;
        b=YqnmS3DzXz1LCK9TnNxoZ1FC42hBXNxEcx0LdJFKGCy+W8y2UJHNRmYEwExVpWaH/Q
         x8ygSJxYTsSgcZQtVYxcNrLu5B303G8rHzGQekjCwSxElQvcfCvKXj1B7Ou9n7Qu5bMl
         kxABs+7NyiKsY+gWqc9eUseSoPLUjr4/KSpAPOAM/2zdYIxEc0cUyeVonggrCU4EdhHG
         cBl69JqdFWce8E2ELP60TcWacmHdBLDYEG4Tas3ALE8F0s5FhTr5LOYsVIswEvJfljFw
         5DBBb+IScwijOHZiBGJ7Vmhahb+XRUXzANv/MvN07XU27BBqg146zs1WTTpqz/ZfkjlV
         zS7Q==
X-Gm-Message-State: APjAAAXCxqWFCbRWh0GzAg0RtAutqFmhfgiQEJHw9yWJVIYCTsd6/sJH
        s9nO5lBmIVC9v6anDehFn4+YlxQYuNztDASDPEw=
X-Google-Smtp-Source: APXvYqxgmJ5eDxIXvf/92CHl1ZgjxTshwoi9tmT7Y5X6PGfEC0kLak0vrNxNNpdA+9i7D0Xc1F4UGQmdjVDiQGb6ueE=
X-Received: by 2002:a05:6602:2252:: with SMTP id o18mr13362891ioo.63.1561771337297;
 Fri, 28 Jun 2019 18:22:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <cover.1561588012.git.cedric.xing@intel.com> <72420cff8fa944b64e57df8d25c63bd30f8aacfa.1561588012.git.cedric.xing@intel.com>
 <f36415e6-5a69-b1b9-74b6-87a9af4508d3@tycho.nsa.gov> <960B34DE67B9E140824F1DCDEC400C0F6551C45F@ORSMSX116.amr.corp.intel.com>
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F6551C45F@ORSMSX116.amr.corp.intel.com>
From:   Stephen Smalley <stephen.smalley@gmail.com>
Date:   Fri, 28 Jun 2019 21:22:05 -0400
Message-ID: <CAB9W1A3Xusf77LZ44HjNYuuFPHv=vditqJZLu6yrStFG3OwHXQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Stephen Smalley <sds@tycho.nsa.gov>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "greg@enjellic.com" <greg@enjellic.com>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jun 28, 2019 at 5:54 PM Xing, Cedric <cedric.xing@intel.com> wrote:
>
> > From: linux-sgx-owner@vger.kernel.org [mailto:linux-sgx-
> > owner@vger.kernel.org] On Behalf Of Stephen Smalley
> > Sent: Friday, June 28, 2019 9:37 AM
> >
> > > lsm.ema.cache_decisions is on by default and
> > > could be turned off by appending =E2=80=9Clsm.ema.cache_decisions=3D0=
=E2=80=9D or
> > > =E2=80=9Clsm.ema.cache_decisions=3Doff=E2=80=9D to the kernel command=
 line.
> >
> > This seems problematic on a few fronts:
> >
> > - Specifying it as a boot parameter requires teaching admins / policy
> > developers to do something in addition to what they are already doing
> > when they want to create policy,
> >
> > - Limiting it to a boot parameter requires a reboot to change the mode
> > of operation, whereas SELinux offers runtime toggling of permissive mod=
e
> > and even per-process (domain) permissive mode (and so does AppArmor),
>
> How about making a variable tunable via sysctl?

Better than a boot parameter but still not amenable to per-domain
permissive and still requires admins
to remember and perform an extra step before collecting denials.

>
> >
> > - In the cache_decisions=3D1 case, do we get any auditing at all?  If n=
ot,
> > that's a problem.  We want auditing not only when we are
> > generating/learning policy but also in operation.
>
> Currently it doesn't generate audit log, but I could add it, except it co=
uldn't point to the exact file. But I can use the sigstruct file instead so=
 administrators can at least tell which enclave violates the policy. Do you=
 think it acceptable?

Seems prone to user confusion and lacks precision in why the denial occurre=
d.

>
> >
> > - There is the potential for inconsistencies to arise between the
> > enforcement applied with different cache_decisions values.
>
> The enforcement will be consistent. The difference only lies in the logs.
>
> >
> > I would suggest that we just never cache the decision and accept the
> > cost if we are going to take this approach.
>
> This will also be a viable option. I don't think any enclaves would be co=
mprised of a large number of files anyway. When SGX2 comes up, I think most=
 enclaves will be instantiated from only one file and defer loading librari=
es at runtime. So in practice we are looking to keeping only one file open =
per enclave, which seems totally acceptable.
>
> Stephen (and everyone having an opinion on this), which way do you prefer=
? sysctl variable? Or never cache decisions?

I'd favor never caching decisions.
