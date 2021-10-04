Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 402E2C433F5
	for <linux-sgx@archiver.kernel.org>; Mon,  4 Oct 2021 23:30:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F1936139E
	for <linux-sgx@archiver.kernel.org>; Mon,  4 Oct 2021 23:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbhJDXc1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 4 Oct 2021 19:32:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229635AbhJDXc0 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 4 Oct 2021 19:32:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BFFA6136F;
        Mon,  4 Oct 2021 23:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633390237;
        bh=Udtw16pKVIgP17TPM8XqdxSYf6lANp9vVo/r8UCLvA4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EhO8RqlPVD2wTwBYAF3E5HXea2fp/gdfPytJYXIfY46Wuv3Al0MZ75BSBm3Bbcjz2
         pMIsfbf3U+QnTxz3VNrnMmPA7xkcFXWFm3MZzLRbdAqKkUylFixsNs+qcsEnI+rS0H
         vrngCtKR1Ima4lvNtNxPGwxQ4LYVn+FT+YIjVW9JyFRllL/AzQd5/s6qqLCDgsFHBd
         d20oMuhZaUTtK9m562ntdpx7MKQVUJW8VfeTpWXRuturb6k2iy/XlfO5yAxtAd1Rkg
         Rg63jv6g6c8p2bxFB+0sMmLNsidoQ1fqFqGBpHBsfyoFJ45HrRDbG69kd8snj81Iih
         pY5tndboTac0g==
Message-ID: <d71fc226253196de6d53ef77752bd094546de296.camel@kernel.org>
Subject: Re: [PATCH v8 4/7] x86/sgx: Add SGX infrastructure to recover from
 poison
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Tony Luck <tony.luck@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org
Date:   Tue, 05 Oct 2021 02:30:34 +0300
In-Reply-To: <20211001164724.220532-5-tony.luck@intel.com>
References: <20210927213452.212470-1-tony.luck@intel.com>
         <20211001164724.220532-1-tony.luck@intel.com>
         <20211001164724.220532-5-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 2021-10-01 at 09:47 -0700, Tony Luck wrote:
> Provide a recovery function sgx_memory_failure(). If the poison was
> consumed synchronously then send a SIGBUS. Note that the virtual
> address of the access is not included with the SIGBUS as is the case
> for poison outside of SGX enclaves. This doesn't matter as addresses
> of code/data inside an enclave is of little to no use to code executing
> outside the (now dead) enclave.
>=20
> Poison found in a free page results in the page being moved from the
> free list to the poison page list.
>=20
> Signed-off-by: Tony Luck <tony.luck@intel.com>


Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

/Jarkko

