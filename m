Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7AE4C433F5
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Nov 2021 22:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5B3B611EE
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Nov 2021 22:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233932AbhKEWRR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 5 Nov 2021 18:17:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233102AbhKEWRR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 5 Nov 2021 18:17:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6ED08611CE;
        Fri,  5 Nov 2021 22:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636150476;
        bh=IgiIT96kP5iugFyRbEgt/qbM2X6IoaiCAs7AL5o9wHA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bZhsL+RC5DXIC6ASH0TpvLjBV8UXk2UbeQttKStVLnk2Jg0iksE3GPsoky5uYcAyX
         w3X8eIG+YRFB1paRWg1hDJS3PS6tfuFiYpiNXpX/4qkk94wiRj6/uipGtHIijTQtbo
         LfQaKnE/z9W3P+d1tO3l6Uq3gEc3iV0vFqZ1BU7REm0TNyiTCoxrclUjzhfCJ/z8cX
         FeQkvFNHlLYBdACDHlrOOomuuMc6xtOazyMa4jHs3JIRTbSZGJZv4hjM3GGyhgx+Sq
         XMOgEepSBS7WkAVCOxn3DR0VkjFiq4EAYf+Yzvi8XwY05DFuPLhqQkis7zEmw1mqfu
         N9VGjb6d+guAQ==
Message-ID: <6655423a30c3ef695516b08fa409bf52d5db5fbc.camel@kernel.org>
Subject: Re: [PATCH v11 2/2] x86/sgx: Add an attribute for the amount of SGX
 memory in a NUMA node
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, reinette.chatre@intel.com,
        tony.luck@intel.com, nathaniel@profian.com,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Date:   Sat, 06 Nov 2021 00:14:34 +0200
In-Reply-To: <YYOK+7OREGsSDhEG@kroah.com>
References: <20211103012813.670195-1-jarkko@kernel.org>
         <20211103012813.670195-2-jarkko@kernel.org> <YYJGzgkLJs6819t8@kroah.com>
         <d3711ca7d612627bb891c10e20c3d569fa6f2bf3.camel@kernel.org>
         <YYOK+7OREGsSDhEG@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2021-11-04 at 08:25 +0100, Greg Kroah-Hartman wrote:
> > static const struct attribute_group *node_dev_groups[] =3D {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&node_dev_group,
> > #ifdef CONFIG_HAVE_ARCH_NODE_DEV_GROUP
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&arch_node_dev_group,
> > #endif
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0NULL,
> > };
>=20
> Yes, that is true for the dev pointer passed to your callback, but what
> about the dev pointers in this random array you are looping over?

Right. I got what you are saying.

I think the most legit place to mark an entry in this array would be
just *before* device_register() in register_node(). It's different from
hugetlb_register_node() because hugetlb code adds its attribute group
with sysfs_create_group().

Similarly, the legit place to unmark an entry would be in
unregister_node(), right after device_unregister().

After writing this I realized something: the device ID is the same
as NUMA node ID. This means that I can rewrite my callback as

static ssize_t sgx_total_bytes_show(struct device *dev, struct device_attri=
bute *attr, char *buf)
{
	unsigned long size =3D 0;
	int nid =3D dev->id;

	return sysfs_emit(buf, "%lu\n", sgx_numa_nodes[dev->id].size);
}

I.e no need to maintain a device pointer.

/Jarkko

