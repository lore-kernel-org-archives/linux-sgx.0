Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74FFDECAAD5
	for <linux-sgx@archiver.kernel.org>; Mon, 12 Sep 2022 10:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiILKrt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 12 Sep 2022 06:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiILKrt (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 12 Sep 2022 06:47:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B8431235;
        Mon, 12 Sep 2022 03:47:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2536261185;
        Mon, 12 Sep 2022 10:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA22C433C1;
        Mon, 12 Sep 2022 10:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662979667;
        bh=JqvZVTquvYu9SykLPcx/npNE2iazBZMw0+uVLw8hkpY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oq+h1G6gk5PSZ51uOpozKg+WiZpYc0MaiCzyZLhWZiQweHG3iKZ1nGwxl8BZ4xNwk
         1ci9MCOCl5+813JWlPuLp18qu5cztW/czMeZqCeRxOPkU8l3ImHJXbhWhZoLTsxQrx
         bO/qmW4j6FFVxB/YE3sew8rFm8Dn0aJOBevmqBAOq99MnnpfqYcGYOyF+HEP2Kjx9F
         K7OZVuZwymOSCiifx3Fh7zse+lG71u5cdgF97L//KrPHPqX5AZzC59BLF7IZJVWq/W
         uMFzy2+HF+r8cA8/dAI4KlOJYtZdzmMupAKIxrP7iCDSdgz+kNEkUfd6gF9Nylx/zo
         Ks2DJ1j8ZedTA==
Date:   Mon, 12 Sep 2022 13:47:40 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com,
        seanjc@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/intel: Clear SGX bit if both SGX driver and KVM SGX
 are not enabled
Message-ID: <Yx8OTDwhqbgvGp4p@kernel.org>
References: <20220909080853.547058-1-kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909080853.547058-1-kai.huang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 09, 2022 at 08:08:53PM +1200, Kai Huang wrote:
> Currently on platform which has SGX enabled, if CONFIG_X86_SGX is not
> enabled, the X86_FEATURE_SGX is not cleared, resulting in /proc/cpuinfo
> shows "sgx" feature.  This is not desired.
> 
> Clear SGX feature bit if both SGX driver and KVM SGX are not enabled in
> init_ia32_feat_ctl().
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Is it a pattern that flags are cleared when they are disabled by the
kernel? I don't know the answer for this.

I could imagine that sometimes you might want to know whether the CPU
supports a feature, even if e.g. your distribution kernel does not.

There's of course other ways to answer such qeustion, e.g. by using
cpuid utility.

BR, Jarkko
