Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98843C433F5
	for <linux-sgx@archiver.kernel.org>; Tue, 28 Sep 2021 02:28:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8469F61247
	for <linux-sgx@archiver.kernel.org>; Tue, 28 Sep 2021 02:28:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238727AbhI1CaO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 27 Sep 2021 22:30:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238720AbhI1CaN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 27 Sep 2021 22:30:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1ADF561213;
        Tue, 28 Sep 2021 02:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632796114;
        bh=FOphkoC2vj9FVirt/4L/mY63v0XHJ9g7ZIdtbYGJD0s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=p5JxgFhq2BRv4Rd3QrMkv3E2iD6cZlm/DwleV0/0qKGU7f0L7Q8H+k7I6j2Pr3hk+
         nhSJUWhLg8fyUlyafWm4COJXNHbW1bls6AmxlznqA95q/rtNP7ncW9wxKhOBWnQc+g
         pBrvs9ICO7DtcCMg4mw2QoGCnxqaJUTcIaxlvLQe6fNvT0dcyX9gH96DdwHSGhtJuz
         3eQD57wI8B6U4ttzT/ikEF5mZihiUfDKy18V763fxEU1WPQnolZcDDJy94BgOt+YPy
         UPLdiGbW7BxnGNZk8UHibtEoAi9KPuv1+VYWNrb0/bCAi+cNOUdyoBCv98Tlv9VP50
         4SBOiOM5vZIIQ==
Message-ID: <29373cabc9ba55463b16b7d8148722997840fbb5.camel@kernel.org>
Subject: Re: [PATCH v7 1/7] x86/sgx: Add new sgx_epc_page flag bit to mark
 in-use pages
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Tony Luck <tony.luck@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org
Date:   Tue, 28 Sep 2021 05:28:32 +0300
In-Reply-To: <20210927213452.212470-2-tony.luck@intel.com>
References: <20210922182123.200105-1-tony.luck@intel.com>
         <20210927213452.212470-1-tony.luck@intel.com>
         <20210927213452.212470-2-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 2021-09-27 at 14:34 -0700, Tony Luck wrote:
> SGX EPC pages go through the following life cycle:
>=20
>         DIRTY ---> FREE ---> IN-USE --\
>                     ^                 |
>                     \-----------------/
>=20
> Recovery action for poison for a DIRTY or FREE page is simple. Just
> make sure never to allocate the page. IN-USE pages need some extra
> handling.
>=20
> Add a new flag bit SGX_EPC_PAGE_IN_USE that is set when a page
> is allocated and cleared when the page is freed.
>=20
> Notes:
>=20
> 1) These transitions are made while holding the node->lock so that
>    future code that checks the flags while holding the node->lock
>    can be sure that if the SGX_EPC_PAGE_IN_USE bit is set, then the
>    page is on the free list.
>=20
> 2) Initially while the pages are on the dirty list the
>    SGX_EPC_PAGE_IN_USE bit is set.
>=20
> Signed-off-by: Tony Luck <tony.luck@intel.com>

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

/Jarkko

