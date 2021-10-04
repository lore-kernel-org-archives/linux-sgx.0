Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3805C433F5
	for <linux-sgx@archiver.kernel.org>; Mon,  4 Oct 2021 23:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C518E6139E
	for <linux-sgx@archiver.kernel.org>; Mon,  4 Oct 2021 23:24:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhJDX0Q (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 4 Oct 2021 19:26:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229635AbhJDX0Q (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 4 Oct 2021 19:26:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35FF961381;
        Mon,  4 Oct 2021 23:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633389866;
        bh=cB0+yyep4o2luudGzCf3dNdj7ywH5yZd/COP4yw54bg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JZQ4WCgFEeXNs3ndlLKS72H+0i1a88jmRyYwjoqKIBglCFUPcvB8ffNihz2lYSYxI
         qmQyXtRnZA1tFdYWKzt/vteYolQoRUluzJ5nSs5NQPbr2WJMhTzkJ4RS3E6hrzRjEU
         pjYr0Uo0LwkB+h980C/CUf/zJB9axWd8hEGFyHOynG9IhFpkvk0ACPCRpXPDy4akd+
         1a9nf/abm2oRnjGioRxbv47/0U3Pj8LFtwlpB+50r+M15CGaPMfwECBd6Gilyp2iaX
         RAgq1GV34llEV8D9qQ7pdrzMqwP/AA1z0KV5PQNGqpZKWKaZJxnEV0Zf8dOwQ3Gu0L
         KedfcjnMhSnag==
Message-ID: <7642e09fa3e9be956708e50fbe02444cb6cb8708.camel@kernel.org>
Subject: Re: [PATCH v8 3/7] x86/sgx: Initial poison handling for dirty and
 free pages
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Tony Luck <tony.luck@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org
Date:   Tue, 05 Oct 2021 02:24:24 +0300
In-Reply-To: <20211001164724.220532-4-tony.luck@intel.com>
References: <20210927213452.212470-1-tony.luck@intel.com>
         <20211001164724.220532-1-tony.luck@intel.com>
         <20211001164724.220532-4-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 2021-10-01 at 09:47 -0700, Tony Luck wrote:
> A memory controller patrol scrubber can report poison in a page
> that isn't currently being used.
>=20
> Add "poison" field in the sgx_epc_page that can be set for an
> sgx_epc_page. Check for it:
> 1) When sanitizing dirty pages
> 2) When freeing epc pages
>=20
> Poison is a new field separated from flags to avoid having to make
> all updates to flags atomic, or integrate poison state changes into
> some other locking scheme to protect flags.
>=20
> In both cases place the poisoned page on a list of poisoned epc pages
> to make sure it will not be reallocated.
>=20
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 14 +++++++++++++-
>  arch/x86/kernel/cpu/sgx/sgx.h  |  3 ++-
>  2 files changed, 15 insertions(+), 2 deletions(-)

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

/Jarkko

