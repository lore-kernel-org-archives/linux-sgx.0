Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD461DE4EC
	for <linux-sgx@vger.kernel.org>; Wed,  5 Mar 2025 07:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741160649; cv=none; b=W6cCxb0t5Bi6rbNpfZSmFedAFn+vEPTsDtA78SVQXFWCb+BVP8cys8qV2SkUcw682eIFJPb6B2DHpPr51p3dnF+JSqT+cPhXfQEoqpk+f8KeP2D4DkJ6lpCJYx2wpxlsSq40Y7JDvfz1o8eizVpIBrwnxwP8foxyDwWITPnyYNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741160649; c=relaxed/simple;
	bh=+kINQXm2pVEBWlPxRwvpeqOlQM01zV3AXy2u/inTjz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=evmD1X0Mh/I1kQ9bY7qmayM6U6BcsvtCmddZsFRMtQRFcjSyyP4SXFYrYqA6MJxh5Ws/EecaDCBaXw9isAmTVT4+D7KsYLpyN8tXBe8MJi+djXxS4YlG3r0gW1TFct7NGYjcKdRTikYkzcImZ9KIomh2+9QaRU8uB54hLUW25vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cVrzKo4A; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cVrzKo4A"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-390cf7458f5so5959756f8f.2
        for <linux-sgx@vger.kernel.org>; Tue, 04 Mar 2025 23:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741160646; x=1741765446; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Nd2HP1Muw3tuVA3Upra6dWW9/n6xW7AV0YgtwAM6x4c=;
        b=cVrzKo4AeEcmUjhO+q1OJlFjBPnkxq3UOgpklWmG657I8ztUe4dKTEFPjjFXUc/Qap
         N6qYtEqs9Q4Yf6gqGpi3QE72Hm0M3pUhldlngSUkASXQtrSK3RLrhX32SwlM5wxf/JFk
         FLgOyIWKOp9YvUwaZug6BOAea0W+XswScVQugT3Tt/GX6X6WUB5+8iM7nZWhBzyjakjI
         8U83ho7/f9y2tvo+ldZraIrewmzXvoUdftxprijkGPnWNAJMRmXTKENHaMQwYTp9WkbX
         VACELC8tDtdYcLVVBrj4cM3mVbYz21REGMCoOSMOOp3Qq59V2XlUuZgBCCkToWlq1isn
         QfUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741160646; x=1741765446;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nd2HP1Muw3tuVA3Upra6dWW9/n6xW7AV0YgtwAM6x4c=;
        b=KBJH+X/aL0nzuVck5/u8cA51z6BeshVtIjRLswhXJ+W11EKCrWz/hcWc3u/KHsisPL
         0ZIdx/qdmQdj48kOSVXa21UHD32bDGH040ceVJArkvt0mWfJN5u/odmG26nFAnOJIObM
         xpldNkL77ltZLtZsmp7kg64Wo5yU/hLzccwiQcaI+6pFUVHO8gbvGz0KGPr3rhgNR66c
         Vo+1tmwmN8LVraWGCMJmxPUcqKkKkGIWJ6ldxLiK6eRb5LlDZ46aQrJ/j0BScm+lqLL0
         Hq3tkvRO/icHKOQpr+UWQeMAdwEt9BT41PauqvJyNfI9ocW7WRJwEB82/VXZlJxCYML+
         Y6zg==
X-Gm-Message-State: AOJu0YzkXbOJ66rfMsgzRD3xDIKJDERc5KvFnUyRIgs1nBLNpo0GIIs+
	yca12YFHBBZr+IsbVFBsbUbpWPGjmIYPjoX9wRKiwAaAck1jNofLhDYlr09F4OkbCOv2XmtLimc
	V
X-Gm-Gg: ASbGncvvHBK+RKPQKgFJlqGJoLq/U8lKgyIpgLtiR7u3o7MRTpzxD/x4dNoRu/6IYiQ
	DbaJIFL3AgzMKbTEhLbOcivF93fLUal4q4Ep903i0bRp9jIMYMsHRbODkdW8qtr/hshWag5xxsM
	GASDRRFFVPlbBxncwUeIKDQqxr9InamDPqN0Mo22WHxXmfDWQo1kQQBqBX2Au480uAzeOP57ti+
	jLYzjlAXWwPVup1GfApcBJB+MjIae3Tq4dP0gMvg3uK95I2ql4F/Or6olr3YYHuoVEacgmmkV9L
	Cz9biVcwAMLkI5+jvVHKY+tGbzEz6iYUfgkJphFnmcSFfhZmFQ==
X-Google-Smtp-Source: AGHT+IHKueX4ZSJGjt9icbOH5/FszuZxkJpFEdCR8bMw+KsILplWoPWQuNCvFB0zgfYt6ZgIa/nLzg==
X-Received: by 2002:a05:6000:1885:b0:390:e2a3:cb5b with SMTP id ffacd0b85a97d-3911f7aee05mr1556444f8f.41.1741160645880;
        Tue, 04 Mar 2025 23:44:05 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-390e484489esm20527762f8f.68.2025.03.04.23.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 23:44:05 -0800 (PST)
Date: Wed, 5 Mar 2025 10:44:00 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: linux-sgx@vger.kernel.org
Subject: Re: [bug report] x86/sgx: Add SGX_IOC_ENCLAVE_CREATE
Message-ID: <25ff0eb0-2730-4cc3-89f5-0e5be68e02e6@stanley.mountain>
References: <c87e01a0-e7dd-4749-a348-0980d3444f04@stanley.mountain>
 <Z8d5n9e4tBZo892q@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8d5n9e4tBZo892q@kernel.org>

On Wed, Mar 05, 2025 at 12:07:27AM +0200, Jarkko Sakkinen wrote:
> On Tue, Mar 04, 2025 at 04:05:45PM +0300, Dan Carpenter wrote:
> > Hello Jarkko Sakkinen,
> 
> Hi Dan, thanks for the report, it is very well put together with all the
> detail it has :-)
> 
> > 
> > Commit 888d24911787 ("x86/sgx: Add SGX_IOC_ENCLAVE_CREATE") from Nov
> > 13, 2020 (linux-next), leads to the following Smatch static checker
> > warning:
> > 
> > 	arch/x86/kernel/cpu/sgx/ioctl.c:75 sgx_encl_create()
> > 	warn: potential user controlled sizeof overflow 'secs->size + ((1) << 12)' '0-u64max + 4096'
> 
> 
> What I tried:
> 
> 1. Installed smatch package to Fedora.
> 2. Cloned git clone git://repo.or.cz/smatch.git
> 
> I get:
> 
> $ O=.clangd ~/work/staging/smatch/smatch_scripts/kchecker arch/x86/kernel/cpu/sgx/ioctl.c
> make[1]: Entering directory '/home/jarkko/work/kernel.org/jarkko/linux-tpmdd/.clangd'
>   SYNC    include/config/auto.conf
>   GEN     Makefile
>   GEN     Makefile
>   CHECK   ../scripts/mod/empty.c
>   CALL    ../scripts/checksyscalls.sh
>   DESCEND objtool
>   INSTALL libsubcmd_headers
>   CHECK   ../arch/x86/kernel/cpu/sgx/ioctl.c
> make[7]: *** [../scripts/Makefile.build:208: arch/x86/kernel/cpu/sgx/ioctl.o] Error 139
> make[6]: *** [../scripts/Makefile.build:465: arch/x86/kernel/cpu/sgx] Error 2
> make[5]: *** [../scripts/Makefile.build:465: arch/x86/kernel/cpu] Error 2
> make[4]: *** [../scripts/Makefile.build:465: arch/x86/kernel] Error 2
> make[3]: *** [../scripts/Makefile.build:465: arch/x86] Error 2
> make[2]: *** [/home/jarkko/work/kernel.org/jarkko/linux-tpmdd/Makefile:1989: .] Error 2
> make[1]: *** [/home/jarkko/work/kernel.org/jarkko/linux-tpmdd/Makefile:251: __sub-make] Error 2
> make[1]: Leaving directory '/home/jarkko/work/kernel.org/jarkko/linux-tpmdd/.clangd'
> make: *** [Makefile:251: __sub-make] Error 2
> 
> Am I using smatch incorrectly?

You're doing it correctly.  I don't know what "Error 139" means...  I'm not
able reproduce this.

> I'd just love to learn how to use it in
> order to make sure that my fix will address the bug.

This is something I'm still working on so it's not published yet.

regards,
dan carpenter

