Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78F5CC4361B
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Dec 2020 22:05:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49B7222D2B
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Dec 2020 22:05:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730057AbgLOWFV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 15 Dec 2020 17:05:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729467AbgLOWE7 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 15 Dec 2020 17:04:59 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E690C0613D6
        for <linux-sgx@vger.kernel.org>; Tue, 15 Dec 2020 14:04:18 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id i7so4483368pgc.8
        for <linux-sgx@vger.kernel.org>; Tue, 15 Dec 2020 14:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=syHwQU1H+sMHPHpfstRHv+eAt3C5whQf9ZSlLwH7JxU=;
        b=oX11CLnoAq++KQ7G4SymkguARAazqb67nDAy2gjvtAYi9uTGod9FcokqnGEAwfZSDN
         W9fgOp5cW/a+8cMp9SHnVyIzL+f0QxN//Qc9+/AHft7zEmaJq2+rr44B0dn82sK/nJsV
         pm0WbkmbWuWvIJzEC5DVJyrQzKKHno9f6oaTGMGOXka/cbsXSQhJNZ+tbT7QgIbnCD83
         JbASkxLIHrGlMisZXjG3FA9qBWJ+eV1VQYSTueGZGXuxso6fyl33LbkLtOhSes2bOosz
         uXS2bb6YRQ6HOUcqjLVtrPMhLiCBldRo+7FiYiHYirObKkRJXQhOUTOpVD7hEEm6nDN1
         IHJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=syHwQU1H+sMHPHpfstRHv+eAt3C5whQf9ZSlLwH7JxU=;
        b=oi2iSzkzzuuUxuCYziLE4Co2dq6ZRtWZQrqJMnpEvte539MGA5E2nfrNhGWGGrLYE3
         PpqRuW1NWqiybFOOstq1Rq/HGV2/tGdBc33M8efF6gLvughAJF4E0ZBU40j/ZnkHR1zq
         VvSUBXDXqe4NczdiI2eZRBz75bHuEXa9ek/ciACjMa/o1YJ+PBK04/oxSJe9fbcPHact
         3pGhInED3UM/mfEf7SJR7JCIYwjBeVnC7LawGXwTtoZhhTKaN/6bWWzesgZmY5Ak0uI7
         FtsjghiHjqlp5zNFLxbB+MSY4VYqbR+MdAkP3kfx72oNd0P5kVKmon2A/l6uKlNmmc1N
         9gMw==
X-Gm-Message-State: AOAM533by/RjarsobNv1YMgWux/NN0WJUrI5qTkDuvgX4psamArlflXT
        yXjftFqNtlqPrE9sYCb+bvmASWpsuT4MZw==
X-Google-Smtp-Source: ABdhPJwVg6fGCwFbSZdMD5V+YrVt3Ug2/gYblGulFInW2CamLlD603kpf2piGiJVLBLbRPFEF8KNVg==
X-Received: by 2002:aa7:9d81:0:b029:19d:ca64:3c62 with SMTP id f1-20020aa79d810000b029019dca643c62mr29969751pfq.16.1608069857667;
        Tue, 15 Dec 2020 14:04:17 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id y1sm92868pff.17.2020.12.15.14.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 14:04:16 -0800 (PST)
Date:   Tue, 15 Dec 2020 14:04:10 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH] x86/sgx: Synchronize encl->srcu in sgx_encl_release().
Message-ID: <X9ky2n7VcGEGmODx@google.com>
References: <20201211113230.28909-1-jarkko@kernel.org>
 <X9e2jOWz1hfXVpQ5@google.com>
 <20201215055556.GA28278@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215055556.GA28278@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Dec 15, 2020, Jarkko Sakkinen wrote:
> On Mon, Dec 14, 2020 at 11:01:32AM -0800, Sean Christopherson wrote:
> > Haitao reported the bug, and for all intents and purposes provided the fix.  I
> > just did the analysis to verify that there was a legitimate bug and that the
> > synchronization in sgx_encl_release() was indeed necessary.
> 
> Good and valid point. The way I see it, the tags should be:
> 
> Reported-by: Haitao Huang <haitao.huang@linux.intel.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> 
> Haitao pointed out the bug but from your analysis I could resolve that
> this is the fix to implement, and was able to write the long
> description for the commit.
> 
> Does this make sense to you?

Yep, works for me.
