Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B6CC43217
	for <linux-sgx@archiver.kernel.org>; Sun, 27 Nov 2022 17:16:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiK0RQx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 27 Nov 2022 12:16:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiK0RQw (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 27 Nov 2022 12:16:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FF0DFC8
        for <linux-sgx@vger.kernel.org>; Sun, 27 Nov 2022 09:16:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13FAEB80B27
        for <linux-sgx@vger.kernel.org>; Sun, 27 Nov 2022 17:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5564DC433D6;
        Sun, 27 Nov 2022 17:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669569408;
        bh=bSo6Mjbli43t2ylqPY00/6eAzaEubHitLNf7gGUPKL0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YGSUEoYXA+PQaPyQ2FbO0IDfMOohe8AZ6AgVSrQvrdq46aBSX7Tc5OVVLAlEgrzHL
         /uQU3JEXuf4hX9nGc3D7Z86wHwsBHi+ztIiwuYaX8/sJm/KRgklHTd1i9EvMqU5juS
         96qL14+uKv11aUvrubl/6pCwUKCYbA/SIJI/D4OqPQZogsjey0+0mdQu8ZPpHvY6cA
         +V+R/LKi2ABzrwZVB9HeBn1b4DPDac6SUJ450U6Cw/aK/YYWlCUdbuNr5F3og59brP
         c7VzruqZEJNzNql2B1nL+gXFaU48EH1RgB/TOkQrXU67Qw85Gq+EeJqMJ8jHnEYACp
         OrvgqsNEwHY/w==
Date:   Sun, 27 Nov 2022 19:16:44 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com,
        reinette.chatre@intel.com, vijay.dhanraj@intel.com
Subject: Re: [RFC PATCH v3 3/4] selftests/sgx: add len field for EACCEPT op
Message-ID: <Y4ObJvPfDoKCdSeR@kernel.org>
References: <20221107220212.257422-1-haitao.huang@linux.intel.com>
 <20221107220212.257422-2-haitao.huang@linux.intel.com>
 <20221107220212.257422-3-haitao.huang@linux.intel.com>
 <20221107220212.257422-4-haitao.huang@linux.intel.com>
 <Y3QfrQFiWtOK3+c+@kernel.org>
 <op.1vqqonrswjvjmi@hhuan26-mobl1.mshome.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.1vqqonrswjvjmi@hhuan26-mobl1.mshome.net>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Nov 16, 2022 at 01:26:46PM -0600, Haitao Huang wrote:
> On Tue, 15 Nov 2022 17:24:29 -0600, Jarkko Sakkinen <jarkko@kernel.org>
> wrote:
> 
> > On Mon, Nov 07, 2022 at 02:02:11PM -0800, Haitao Huang wrote:
> > > So we can EACCEPT multiple pages inside enclave without EEXIT,
> > > preparing for testing with MADV_WILLNEED for ranges bigger than
> > > a single page.
> > > 
> > > Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
> > > ---
> > >  tools/testing/selftests/sgx/defines.h   |  1 +
> > >  tools/testing/selftests/sgx/test_encl.c | 20 ++++++++++++++------
> > >  2 files changed, 15 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/tools/testing/selftests/sgx/defines.h
> > > b/tools/testing/selftests/sgx/defines.h
> > > index d8587c971941..8578e773d3d8 100644
> > > --- a/tools/testing/selftests/sgx/defines.h
> > > +++ b/tools/testing/selftests/sgx/defines.h
> > > @@ -60,6 +60,7 @@ struct encl_op_eaccept {
> > >  	struct encl_op_header header;
> > >  	uint64_t epc_addr;
> > >  	uint64_t flags;
> > > +	uint64_t len;
> > >  	uint64_t ret;
> > >  };
> > > 
> > > diff --git a/tools/testing/selftests/sgx/test_encl.c
> > > b/tools/testing/selftests/sgx/test_encl.c
> > > index c0d6397295e3..fc797385200b 100644
> > > --- a/tools/testing/selftests/sgx/test_encl.c
> > > +++ b/tools/testing/selftests/sgx/test_encl.c
> > > @@ -35,14 +35,22 @@ static void do_encl_eaccept(void *_op)
> > >  	struct sgx_secinfo secinfo __aligned(sizeof(struct sgx_secinfo)) =
> > > {0};
> > >  	struct encl_op_eaccept *op = _op;
> > >  	int rax;
> > 
> > Should be empty line after declarations.
> > 
> > > +	if (op->len == 0)
> > > +		op->len = 4096;
> > 
> > What is this?
> 
> Existing test cases is always eaccepting one page at a time.
> With the new len field, this is to set value to 1 page by default so no
> changes in other places is needed.
> I can add a comment in struct encl_op_eaccept declaration or let me know if
> you prefer a different way.

Please set op->len properly in all test cases.

BR, Jarkko
