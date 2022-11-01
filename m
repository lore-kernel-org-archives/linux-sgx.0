Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC8EFA3740
	for <linux-sgx@archiver.kernel.org>; Tue,  1 Nov 2022 00:50:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiKAAuH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 31 Oct 2022 20:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiKAAuG (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 31 Oct 2022 20:50:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AAAFBC91
        for <linux-sgx@vger.kernel.org>; Mon, 31 Oct 2022 17:50:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 897E361502
        for <linux-sgx@vger.kernel.org>; Tue,  1 Nov 2022 00:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54EA5C433D6;
        Tue,  1 Nov 2022 00:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667263802;
        bh=qHttP4ehOQU9GvMyFcT0Cm1iLtGXoVKJbcUm4xnsFbc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vo22kz1xWJlLqnJ2FAQC994IiTGe20CG2fJ+U+TC4sZPGnMqwsmTQlnknYmOzqg2C
         /vYjOeAJbSEEc/gpE9j55gwNG8vZ7DLssiwz5gTr2H0FE+yMAzz7n+VU9jdibh1lhT
         ADJ9ZCESvGMKE723oYkVu9Ax/KqIalfKIKQkGUjsa90DXbEmC8tlnHs0XcFpKhEylv
         NNPoUViO5oSiuRvUzyEsx22ggup4Tzt8S7wpBM5C/zQR8Vzho8AnUjTMqAxl97jMRA
         Ky5+UzHITBGChthdtHYFGsFEG5TPUV62zaTGTWi/n3v2v7kn9mJCkfkKmgLY+ROym2
         u5tw+oVcirTDQ==
Date:   Tue, 1 Nov 2022 02:49:58 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com,
        reinette.chatre@intel.com, vijay.dhanraj@intel.com
Subject: Re: [RFC PATCH 2/4] x86/sgx: Implement support for MADV_WILLNEED
Message-ID: <Y2BtNjwNO8PkIpvd@kernel.org>
References: <20221019191413.48752-1-haitao.huang@linux.intel.com>
 <20221019191413.48752-2-haitao.huang@linux.intel.com>
 <20221019191413.48752-3-haitao.huang@linux.intel.com>
 <Y1Ww0vEHcQDitaYJ@kernel.org>
 <op.1ujtxux7wjvjmi@hhuan26-mobl1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.1ujtxux7wjvjmi@hhuan26-mobl1.amr.corp.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 24, 2022 at 10:14:03AM -0500, Haitao Huang wrote:
> Hi Jarkko,
> 
> On Sun, 23 Oct 2022 16:23:30 -0500, Jarkko Sakkinen <jarkko@kernel.org>
> wrote:
> ...
> > > +	/* Here: vm_start <= pos < end <= vm_end */
> > > +	while (pos < end) {
> > > +		if (xa_load(&encl->page_array, PFN_DOWN(pos)))
> > > +			continue;
> > > +		if (signal_pending(current)) {
> > > +			if (pos == start)
> > > +				ret = -ERESTARTSYS;
> > > +			else
> > > +				ret = -EINTR;
> > > +			goto unlock;
> > > +		}
> > > +		ret = sgx_encl_eaug_page(vma, encl, pos);
> > 
> > You should instead just do the export in the previous commit,
> > and convert the return values here. Less pollution to the
> > existing code base.
> > 
> 
> Thanks for the feedback. Just to clarify, you prefer following:
> 
> 1. do export only in separate patch, no return type and value change
> 2. change return type and value in this patch.
> 
> Note the sgx_fadvise function needs to stop EAUGing and return in case of
> -EBUSY. So sgx_encl_eaug_page has to return error code -EBUSY separately,
> instead of lumping -EBUSY with VM_FAULT_NOPAGE which was fine for page fault
> handler.

I guess the problem is that any of this is not explained in the commit
message, i.e. should already answer to this question. My preference is
argumented solution.

BR, Jarkko
