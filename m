Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 875A4C433F5
	for <linux-sgx@archiver.kernel.org>; Wed,  3 Nov 2021 21:54:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69D7A6113E
	for <linux-sgx@archiver.kernel.org>; Wed,  3 Nov 2021 21:54:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhKCV5c (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 3 Nov 2021 17:57:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229968AbhKCV5a (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 3 Nov 2021 17:57:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D84960E08;
        Wed,  3 Nov 2021 21:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635976493;
        bh=3dU1WD3jK0GFDms72I0PUOjozVCuxCQ/CRp8xAbQb2w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LwLcXvGU3FEntjq529Jt9N0Oer46ORHvmXKIxizy6UkLE8rZ+paiFur98d08GQ1X1
         LVmAUvUFx50Tu/bJFp7DfyPlmnYHRx7UhXN1Jq6t0cBEmE1kiquxOTBmL8sYF7PUn5
         VPVfTyNsls4DC845OgiukVyP8LRtqzNuIYO/AfoNIzfk19sl+knOC1Ivs9NCD4vsgf
         gO4/7Ce2IwxKBp227eB12Vw+xH/bDco1L6W1+NGjeJS6Iow8BUXOCqFUs+WkLfDLDQ
         pTnymZF4r1l7WVtiABmrL1TNboKz0y6NcGAKH8cVt/cay6jR+P7688ARmlUpg2qf/A
         jsxmJGvA8M39w==
Message-ID: <7c859ba3feefe50fc84f5050e50465a5ffe3f572.camel@kernel.org>
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
Date:   Wed, 03 Nov 2021 23:54:50 +0200
In-Reply-To: <d3711ca7d612627bb891c10e20c3d569fa6f2bf3.camel@kernel.org>
References: <20211103012813.670195-1-jarkko@kernel.org>
         <20211103012813.670195-2-jarkko@kernel.org> <YYJGzgkLJs6819t8@kroah.com>
         <d3711ca7d612627bb891c10e20c3d569fa6f2bf3.camel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 2021-11-03 at 23:49 +0200, Jarkko Sakkinen wrote:
> On Wed, 2021-11-03 at 09:22 +0100, Greg Kroah-Hartman wrote:
> > That's not the proper thing to do here at all, these values should be
> > part of the device structure that this attribute lives on, in order to
> > properly handle all of these reference counting and locking issues
> > automatically.
>=20
> The attribute group is part of the device structure, so in that sense
> it is already like this. And I think that all NUMA node specific data
> (most of which is unrelated to device sysfs) is best kept in the private
> struct.

If you are concerned that the SGX driver might go away when NUMA code
calls it, I can address that concern too.

The memory management code if arch/x86/kernel/cpu/sgx is not associated
with the user space facing driver. E.g. you can use memory manager with
KVM without having the driver even enabled in the kernel.

This include the numa code in the SGX subsystem. It's life-cycle is the
same as the power-cycle. It is guaranteed that any possible time during
the power cycle, when that sysfs callback is called, all the data is valid.
That's why it is safe to be part of the attribute groups of the NUMA
device.


/Jarkko

