Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3822FC433F5
	for <linux-sgx@archiver.kernel.org>; Mon,  4 Apr 2022 21:53:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239248AbiDDVzC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 4 Apr 2022 17:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386981AbiDDVjw (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 4 Apr 2022 17:39:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113892CC87
        for <linux-sgx@vger.kernel.org>; Mon,  4 Apr 2022 14:31:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EE8FB81A1F
        for <linux-sgx@vger.kernel.org>; Mon,  4 Apr 2022 21:31:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BC2C340F2;
        Mon,  4 Apr 2022 21:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649107885;
        bh=utE/TUsHHngn6wxfMptshBuAOCieALwf07nQyLoBAhw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=M3esq13FVlEqwG10M3w9xn+BcKk2MhWXdcZKZG4dlYnJ0Xjq4Xykh2MCeZYcCOUSG
         u8+gKwL1Hi+uLtNW8x+BDPUgJ0xjwJlJTSleuR2k2y2arTnQ4Bt+6fIFtbv/ZDbL4Z
         EVvh9yzb7+Zp1m5f/6y0fRhUEJ0l2J8etDKjFEGGNp8/EsCaQwFvRrlmGIcn1vnMxy
         iy/U+zOSLIKeZHqpaE5M6qpRlvRLVGjKn25XOyXe8Sud6h/TnfESfF35zt+pUtn9ym
         E44e9Pyb8l15MIW4OUri2pjPb/yaduDon+8X4CsnknGf44Pcw6taOC4KKMZEF+yJGH
         zRiESfHd908Vw==
Message-ID: <2ad3f46e4cb6298da0b04a2f338d13e9dcca1c78.camel@kernel.org>
Subject: Re: Odd looking #PF fault code
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     dave.hansen@linux.intel.com, reinette.chatre@intel.com
Date:   Tue, 05 Apr 2022 00:32:35 +0300
In-Reply-To: <YkoyvdqIqkaOk8NL@kernel.org>
References: <YkoyvdqIqkaOk8NL@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 2022-04-04 at 02:50 +0300, Jarkko Sakkinen wrote:
> I get this when trying to get EAUG-EACCEPTCOPY to run on Enarx and I get:
>=20
> Unexpected PF: address: 0x007f7fff910000, error code 0x15
>=20
> I'm using patches from:
>=20
> https://github.com/rchatre/linux/tree/sgx/sgx2_submitted_v2_plus_rwx
>=20
> Fault code is in other words PROT|WRITE|USER|RSVD.
>=20
> According to arch/x86/kernel/fault.c:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Reserved bits are neve=
r expected to be set on
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * entries in the user po=
rtion of the page tables.
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (unlikely(error_code &=
 X86_PF_RSVD))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0pgtable_bad(regs, error_code, address);
>=20
> Any clue how this fault code could emit?
>=20
> [*] https://github.com/enarx/enarx/pull/1608
>=20
> BR, Jarkko

Oops, off-by-one, I bit is set, not RSVD :-)

BR, Jarkko

