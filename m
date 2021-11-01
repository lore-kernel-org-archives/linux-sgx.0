Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11440C433EF
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Nov 2021 00:01:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDF2B610A2
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Nov 2021 00:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhKAAEM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 31 Oct 2021 20:04:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230121AbhKAAEM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 31 Oct 2021 20:04:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 591AB60FC2;
        Mon,  1 Nov 2021 00:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635724899;
        bh=nZ9T23ohCusqaZPcl4A906nALO+MSjH/F5bmO0wM0KE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FuAM7in5lQtaBcUsXBG/IhPMXGl/dBFzblPLcrP6UmtrkTf0GEx1o8U0Eue+IXwP4
         3fG9FoflNRnAstNcG1VeKpoZ1AAdRZ8lEIBQGThLDH65Yn4zGgbhBi1n/IfG9qQpFB
         Xwk3tmQoLmttkeSTzK1ypSIB051IRvM1Fonci38YIB82eq1lQ1SVRfMqEIw30maGrM
         nmeWgzXwhpBHU1QrGeU5gJjGiTDI14fRR9JmRieSiXB4yeaV15KiQsMQjw2tQA7wId
         RHjxFCwnnDnQNLEElSeqkR9qIhdqwvxuAgf0IZ7ILJhPXTkx8ZD1k6LguDWELuhNiS
         tT/8/65heWmCg==
Message-ID: <256be690a45eb4a01a508b911fa5950f26c91f96.camel@kernel.org>
Subject: Re: [PATCH v9 2/2] x86/sgx: Add an attribute for the amount of SGX
 memory in a NUMA node
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     reinette.chatre@intel.com, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Date:   Mon, 01 Nov 2021 02:01:37 +0200
In-Reply-To: <4e5cdd5825018778ad15abed33242703b8066e76.camel@kernel.org>
References: <20211029121857.477885-1-jarkko@kernel.org>
         <20211029121857.477885-2-jarkko@kernel.org>
         <3ffafe28-e770-a285-98d0-1379271ba36d@intel.com>
         <4e5cdd5825018778ad15abed33242703b8066e76.camel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, 2021-10-31 at 19:49 +0200, Jarkko Sakkinen wrote:
> On Fri, 2021-10-29 at 10:00 -0700, Dave Hansen wrote:
> > On 10/29/21 5:18 AM, Jarkko Sakkinen wrote:
> > > +What:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/sy=
s/devices/system/node/nodeX/sgx/size
> > > +Date:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Oct=
ober 2021
> > > +Contact:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Jarkko Sakkinen <j=
arkko@kernel.org>
> >=20
> > I don't think we should do something *entirely* SGX-specific here.=C2=
=A0 The
> > only question to me is whether any non-SGX users want something like
> > this and who they are.
> >=20
> > Here are some ideas I like more than an "sgx/" directory:
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/sys/devices/system/nod=
e/nodeX/arch/sgx_size
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/sys/devices/system/nod=
e/nodeX/x86/sgx_size
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/sys/devices/system/nod=
e/nodeX/coco/sgx_size
>=20
> Sure, I can rename the attribute group as "x86".

Dave,

So, if I rename sgx_node_group as arch_node_dev_group, we also need
something like CONFIG_ARCH_HAS_NODE_DEV_GROUP defined in arch/Kconfig,
so that the group definition in drivers/base/node.c becomes:

static const struct attribute_group *node_dev_groups[] =3D {
	&node_dev_group,
#ifdef CONFIG_ARCH_HAS_NODE_DEV_GROUP
	&arch_node_dev_group,
#endif
	NULL,
}

Does this make sense to you, and reflect your feedback in a=C2=A0
reasonable manner?

/Jarkko

