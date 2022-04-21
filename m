Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50258C433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Apr 2022 12:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383084AbiDUMKF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Apr 2022 08:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351963AbiDUMKE (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 21 Apr 2022 08:10:04 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B609252B2
        for <linux-sgx@vger.kernel.org>; Thu, 21 Apr 2022 05:07:14 -0700 (PDT)
Received: from zn.tnic (p200300ea971b581b329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:581b:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0663B1EC013E;
        Thu, 21 Apr 2022 14:07:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1650542829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=gxJYLZlgkZ7gVHjCG73fuNiFzWSZRL6W/fwShw55jwc=;
        b=b9pjixYy9t1o6gD66LWeW6Se9d0VBwGyuK08ZdOB6FHCEjxI1HpCGlSuTABIDLQDa2KOOO
        oGKT9zFpfeUGI/Kdcrr7iQCKXn5nTk4RfwPypycZ1NuBfsDGN/VlBCgcyXeEjJH2gqTqhA
        b7fglqeZOHguw2sQffvMOKKYFCEKMWY=
Date:   Thu, 21 Apr 2022 14:07:08 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Cathy Zhang <cathy.zhang@intel.com>
Cc:     linux-sgx@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        reinette.chatre@intel.com, dave.hansen@intel.com,
        ashok.raj@intel.com, chao.p.peng@intel.com, yang.zhong@intel.com
Subject: Re: [PATCH v4 8/9] x86/cpu: Call ENCLS[EUPDATESVN] procedure in
 microcode update
Message-ID: <YmFI7OiWRaWNNsGM@zn.tnic>
References: <20220421110326.856-1-cathy.zhang@intel.com>
 <20220421110326.856-9-cathy.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220421110326.856-9-cathy.zhang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Apr 21, 2022 at 07:03:25PM +0800, Cathy Zhang wrote:
> diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
> index d6bfdfb0f0af..ec12392af371 100644
> --- a/arch/x86/include/asm/microcode.h
> +++ b/arch/x86/include/asm/microcode.h
> @@ -3,6 +3,7 @@
>  #define _ASM_X86_MICROCODE_H
>  
>  #include <asm/cpu.h>
> +#include <asm/sgx.h>

That include looks like a leftover.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
