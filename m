Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C440C56201
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Nov 2020 16:09:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1ABD246CE
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Nov 2020 16:09:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="UdwV4liL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbgKSQJ3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Nov 2020 11:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbgKSQJ1 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 19 Nov 2020 11:09:27 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64DBC0613CF
        for <linux-sgx@vger.kernel.org>; Thu, 19 Nov 2020 08:09:26 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id k2so7063489wrx.2
        for <linux-sgx@vger.kernel.org>; Thu, 19 Nov 2020 08:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iI8xzLfXWyQElYOVmD8N7wrPoRdV2kVk95Atj+cXy8M=;
        b=UdwV4liL6MJErYhJAGttt+lFW0u7a8J8RT45bO31jz7/3SIfMm7LKu9eNGT/NwbRbe
         b88Y+1GRyv+R2e8GlZ+ehkXdnpuK1FHnDTJ7ua2QoL3vHp3/ik0e0rsrQFCo0I+EqF9O
         uNVBSDgGR76LVFoEVsJHVY/2BQVYhOPMb65/McB7Vsp6x6XDtHZlPTpziXYDCHMBNbQX
         bbj2D5iCGACp/wp6rxLTpZxmRDmraESo9qR9riHO3TzjNKwefvVjH/1wQSiBtfKAr8oC
         sdAlVCJY1bApCUaGxsGtbf6m6lruvHt6AP7EujYh/fR/FiQJF+iNwrI6e0Ns5Uxi+2Ad
         V1Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iI8xzLfXWyQElYOVmD8N7wrPoRdV2kVk95Atj+cXy8M=;
        b=alEDYL7iIH5i9vQ6gqAZDyFxOl2oDpRcG+1Fc9YG9s8c6yZ9GY4dJJLzy9Rp/ZStb2
         8oW6YdnIjxPm0BfASsUP+DKC+WlBPyPTR5gvKi9iZzwN91VBJRNHhO6dzl+43uPyrNNa
         LzyzqWt+WZXNZI+h3NlSJ/mcA6ONdAL1H+YQIypcs/JXuHrunjHNAX2CjaxCbX1v9cgr
         HBW47KHCSWnDtYS6rGYoyJmq+GpdT1XxnvylH0QVImdOpi5o/0h9kgBkNKUWingjv3l+
         ZFXnQfHlZeUJXZRqjyUrl/LSRYyEcQ3CsoDmcFAIUocbJh8S2A/dH6hGeUQqFECMlNXd
         G+fw==
X-Gm-Message-State: AOAM531XmGRWan7h7Chi9DX1PLsUwGEUPLAIhmgJxvSmFKBElEqf8eoa
        y7b9w4z3KOSmJYgFwz8deE/1+j0hbN3aIRTQIONa3DCKy272nw==
X-Google-Smtp-Source: ABdhPJxG3DXKY4E6T4NrlqMSPslm0R5VOpOXs0VuEbe7aSj1ec1HUpALrWrrclsVAbyKwpfw4EfwRhQRuB7nhzTcUpE=
X-Received: by 2002:a5d:4991:: with SMTP id r17mr11060280wrq.70.1605802165603;
 Thu, 19 Nov 2020 08:09:25 -0800 (PST)
MIME-Version: 1.0
References: <20200406185530.GE20105@linux.intel.com> <F4B63BCD-F554-4BE2-B3AE-4ADB6C2F4285@amacapital.net>
 <4cd754dd-7230-be12-fd55-f2d45c68e0d9@fortanix.com>
In-Reply-To: <4cd754dd-7230-be12-fd55-f2d45c68e0d9@fortanix.com>
From:   Andy Lutomirski <luto@amacapital.net>
Date:   Thu, 19 Nov 2020 08:09:11 -0800
Message-ID: <CALCETrVBO8ceeT8qXw2rDQgdzJH8U-YLpYNMDGC0VudD4VgTCQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Topi Miettinen <toiwoton@gmail.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Ben Hutchings <ben@decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Nov 18, 2020 at 11:23 PM Jethro Beekman <jethro@fortanix.com> wrote=
:
>
> On 2020-04-06 21:53, Andy Lutomirski wrote:
> >
> >
> >> On Apr 6, 2020, at 11:55 AM, Jarkko Sakkinen <jarkko.sakkinen@linux.in=
tel.com> wrote:
> >>
> >> =EF=BB=BFOn Mon, Apr 06, 2020 at 09:44:19AM -0700, Andy Lutomirski wro=
te:
> >>>
> >>>>> On Apr 6, 2020, at 4:01 AM, Topi Miettinen <toiwoton@gmail.com> wro=
te:
> >>>>
> >>>> =EF=BB=BFOn 6.4.2020 9.42, Jethro Beekman wrote:
> >>>>> On 2020-04-04 09:27, Topi Miettinen wrote> Then initramfs should ma=
ke a similar exception as with v86d and grant exec to /dev.
> >>>>> I'm not sure this is a reasonable approach. Expect most devices wit=
h an Intel processor will have the SGX device going forward. Then, no one i=
s using noexec, so why have this logic at all?
> >>>>
> >>>> Intel does not control the whole market yet, does AMD also offer SGX=
 or similar? Will SGX be also available for consumer devices? Are distros g=
oing to enable SGX, will it benefit their users somehow?
> >>>>
> >>>> Perhaps the sgxfs approach or something else (system call?) would be=
 better after all in order to not force exec just because of one device. /d=
ev is usually writable, so allowing exec means breaking the W^X principle f=
or filesystems.
> >>>>
> >>>>
> >>>
> >>> It=E2=80=99s *possible* to create a tmpfs, create the sgx nodes on it=
,
> >>> bind-mount to /dev/sgx/..., and lazy-unmount the tmpfs.
> >>>
> >>> I don=E2=80=99t know whether udev would be willing to support such a =
thing.
> >>
> >> sgxfs is somewhat trivial to implement and has one stakeholder less to
> >> worry about. It is not really a huge stretch.
> >>
> >> Overally, I think it is something that we could live with. At least it
> >> is something that does not step on others toes.
> >>
> >> Haitao: If we go with sgxfs route, then you can for the moment do what
> >> Andy suggested: bind mount it to /dev/sgx.
> >
> > That also needs userspace support.
> >
> > I=E2=80=99ll start a thread on the udev list.
>
> Andy, can you send a link to this thread?
>

Hmm, I may never have sent the email.  Let me do this right now.
