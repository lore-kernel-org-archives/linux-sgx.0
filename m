Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9906C433F5
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Oct 2022 21:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiJDVuz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Oct 2022 17:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiJDVux (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 4 Oct 2022 17:50:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ACE82B625
        for <linux-sgx@vger.kernel.org>; Tue,  4 Oct 2022 14:50:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38D12B81BD7
        for <linux-sgx@vger.kernel.org>; Tue,  4 Oct 2022 21:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E63C433D6;
        Tue,  4 Oct 2022 21:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664920249;
        bh=k1lmPmqE3A2/IXXxi3/c/6EbBVviNACEa/xgYe4Iec8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zb5HqgxfenAb1XWOF20e58s06Y2EdvrXUp8UVtIkvzp2W3bPfl95k+MZKE+AiUBLk
         eV9rmFoqDsBsTxCvpQ6VquaPPtLjY25uFTJXO//COBOmuYo4daKphxgeqYvCfN70YS
         JFzgd2upAyE010nlDsZe2F84+VVHFwACBaTJesU9yv+MJCuySddRzZhodeJ5oeH7mM
         RSLAv/HFhT05ibcvQk/a6l+5ZwurbFsM2Axm0bHUDl31rBIMQQ+08nweX6rFfUJ0TC
         35UWTppmkv3YM7cUGh9FJPEp8Wq4ZACWwLxI/z6y5dZUVq19ecS+uUqXTuDhWHHL3J
         7W87VRti9SGdw==
Date:   Wed, 5 Oct 2022 00:50:46 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Borys <borysp@invisiblethingslab.com>
Cc:     dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org,
        mkow@invisiblethingslab.com
Subject: Re: sgx_validate_offset_length bug
Message-ID: <YzyqttbWmjqzH7At@kernel.org>
References: <9e1e61cf-39d9-8039-b2e4-f0a3804fe493@invisiblethingslab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e1e61cf-39d9-8039-b2e4-f0a3804fe493@invisiblethingslab.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 03, 2022 at 07:19:21PM +0200, Borys wrote:
> Hi,
> 
> I've stumbled upon "sgx_validate_offset_length" function in
> "arch/x86/kernel/cpu/sgx/ioctl.c" (all of this is based on 6.0-rc7
> version), which does not entirely do what it claims. "offset" and
> "length" parameters are provided by userspace and as such their addition
> can overflow, which may result in this function approving malicious
> values. Fortunately this does not result in any exploitable bugs at the
> moment (or at least I couldn't find any), but this might change if
> "sgx_validate_offset_length" is used in a new context or current usages
> are changed, so it might be worth fixing anyway. Simple overflow check
> `offset + length < offset` should be enough.
> 
> Best regards,
> 
> Borys
> 

I agree with the bug but not on security issue.

If you can call the ioctl API in the first place, you can already apply
the operations in arbitrary locations inside the enclave, i.e. it does
not introduce any new capability to the untrusted runtime.

BR, Jarkko
