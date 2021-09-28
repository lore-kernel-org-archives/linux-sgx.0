Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9104C433EF
	for <linux-sgx@archiver.kernel.org>; Tue, 28 Sep 2021 03:01:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3AA2611CE
	for <linux-sgx@archiver.kernel.org>; Tue, 28 Sep 2021 03:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238655AbhI1DDT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 27 Sep 2021 23:03:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238710AbhI1DDT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 27 Sep 2021 23:03:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4751961156;
        Tue, 28 Sep 2021 03:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632798100;
        bh=etcWicIya78aAu3YgO2YZU7Km62u3r0LRoISmor1eqk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RZH11clboMwjHRzownDyG7gYVL9PPmQcoKVi2Lus11wvBCli72L/0F69o3iXvnrdW
         4alwwpmN1cEx4jnbs3cRFxBsXBRHxwIT4MAoPOosfu2DLFBlCv1J4i/GDec6g6Kere
         0na4r8UNblarbPQatQr5nwYrILfBtrjNMd+QH4xgNU74lzJ71oZCY9PqC/BCM0HAB1
         I5d33KBl0YbxLT5oheLEVT6F+8nATnH8V9rwJRjGtioC+izah85Y7ZkHoLifobjGWi
         nr02yo+WUYSmQNxx8cMUSexOG1byzo9u488Uwq+NYo7TxnqGK4abYnud4hHK1LFDXC
         baGQ+Bj6QBayg==
Message-ID: <20d92bf2ae51aac2e5acaf5a206f7cdbb065904b.camel@kernel.org>
Subject: Re: [PATCH v5 2/2] x86/sgx: Add an attribute for the amount of SGX
 memory in a NUMA node
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Date:   Tue, 28 Sep 2021 06:01:38 +0300
In-Reply-To: <0f75a6db-27e6-dfc5-4025-e81d8e753e30@intel.com>
References: <20210914030422.377601-1-jarkko@kernel.org>
         <20210914030422.377601-2-jarkko@kernel.org>
         <f45245ba-41b8-62ae-38b5-64725a214bad@intel.com>
         <254864594af4cde213a37a4db527e293a1ef1d7a.camel@kernel.org>
         <0f75a6db-27e6-dfc5-4025-e81d8e753e30@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2021-09-23 at 13:39 -0700, Reinette Chatre wrote:
> Hi Jarkko,
>=20
> On 9/23/2021 1:30 PM, Jarkko Sakkinen wrote:
> > So cat you pick these patches to your patch set, and squash
> > this fix to it?
>=20
> My patch set is focused on SGX selftests while this series target the=20
> x86 tree. I assumed that this series would go into x86 separately and=20
> after they land we can proceed with the SGX selftest work.

But now your series has no chance to be applied, given that
it contains patches which have discarded given a superior
approach.

Anyway, node fields are initialized here:

		if (!node_isset(nid, sgx_numa_mask)) {
			spin_lock_init(&sgx_numa_nodes[nid].lock);
			INIT_LIST_HEAD(&sgx_numa_nodes[nid].free_page_list);
			node_set(nid, sgx_numa_mask);
		}

The correct way to fix the issue is to add

			sgx_numa_nodes[nid].size =3D 0;

Using kcalloc() would not be very sound, since you would wastefully
initialize the pre-existing fields of the struct two times: first
with zeros, and then with "real" values.

/Jarkko

