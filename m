Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1073A0B31
	for <linux-sgx@vger.kernel.org>; Mon, 30 Mar 2026 21:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774905986; cv=none; b=Wcyk49nlFmeXbDYCPJv8vNYKr/zm6M4wZbr4JejfU90ijsdc2BtmoeADq32nPax559L89oknPXSwTvnZlGP/0zO+hFW+qiohNhJfIybQ9PKzYE72pAlGaXeoa2znjSBngYGs6i1e4WgoZW2AhhUXTtvMCPFWOkI761AlofcUMIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774905986; c=relaxed/simple;
	bh=IZ9ZkHUoQhZsvM/C8omthZ8ceGrCRw32aqXvaFTpwbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4TwTCoRQr0L0aWEKNUSTr5MyWWIQrkpRh86gLl0goHwnWsVYV4j370QgSTXGAYox/aEfFBtzh+ArRItJU0JjHdJcTKcB+UggToiRnfryIVqduzZrvE1+lEf1beBNCTg6ulwBbg6GRxaR9dCsfetqcuEOp+appl+141CdmyAGaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tozplluf; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tozplluf"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8cd7284782dso306190585a.1
        for <linux-sgx@vger.kernel.org>; Mon, 30 Mar 2026 14:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774905984; x=1775510784; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jcdiOnXhMMRUjX/q4a6rUlYHVPQJwj3secj4OvAlXSo=;
        b=Tozpllufi7do0T/Knljb1R/xSuir0xP77wuxuyVinDkWZcrRvU6JIjq4E3XZdjCdUG
         pgM3S8p69zhpXdL/pKEfif8CB1VNbDG/1gNPHw5zC0XeRiqLNFesIC16zFDYxX4GDELu
         Dcq6iDOPEWvG8L5WqgxD4G41lpUjU2/csPjwPXi/sK/Gw7FDEr9wY4sVMmMY17oDjiq8
         8XJwTVR26LorJ3GVYlmPv/iWOma0GaJtMKAW4qan4jMBDx5NHQnhg+FODWMBpX8qeEwy
         7y38T7QMtJI4i00zeXOGZB4VvmS9CMlKz65j2rsKyfv51rDF9Keojaae9f7zgnUyQQRn
         yWrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774905984; x=1775510784;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jcdiOnXhMMRUjX/q4a6rUlYHVPQJwj3secj4OvAlXSo=;
        b=KeRzPaQbFFMFfNEYe9IFRo02GywOxj6h/qH/MhVWZQK8l4z/2Lr2ObAlC5qYNq9xJU
         ao056IKc5DgBC0livnhl63f6EAzihshyZL3vV1BE/9LK4BlWYp7gv9PHgiHbw63wFtmu
         dKzc4bLCzUvTWHUIsNKUG09klOrvo5Mfvm5fPAqyQJvn/QPB4kblqE8NR4YSz0bYXJjo
         EZjLkNZ+1CaQOBGh6rV7UpfQ6+jRdmkN2+pYwS6/7vWXvB97IQXuctqu8FIRYcv7ZTtk
         IRMLEYLjDTxXTG+9/OphQxDhizComH/BXqEVOGjAHu8CasW2qSLa+9OFPh/Pwc4RCewN
         JGAg==
X-Forwarded-Encrypted: i=1; AJvYcCU09indMyqSfbkcm4cluAoBkmfwFsJwxNQEhMOF9IJwT0TlA8BOTihw9LkclRifga2FeHpT4/9VbKk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxagHEBKcnlscDX6sfaTxb31Ucs8MsFPNajSB0cG88kPMp9oxnr
	l4bLdGwNeai605cW1cDiOsGts+XeC2EjNd5xsZ8vRC/3yFv5CLn5oXL9Tcle+O57
X-Gm-Gg: ATEYQzxMWqpEZwJ8YC9mGRbbF6fjpX6YGkC9HJnTHP6cqsCNgtrf4GigUVRPifIoOnw
	XgYRjchLYexRgS6qhjcxx0ZOWeuaSDO0iWQ13IYlMWL1aewyOQElogvxo3PsSudQ3vmUfMj2amC
	a9Hgf5BTFyJi0Oq1zTzVALSGFyQFyawuicewmm/1SOP2N1X8PbacOzkBtiaqlwpBBlzFVXNs4oq
	ZdcgFpC/HPJ8fih0ZLyuGYFaEB/hVJbeVGmA4Bj4MLs8EuWo1gMjHwNAbszfSZ29QYsthWu6DhP
	HjilZJ4h4oe2CypJ2uG961W3C9u9MnKrZtvfoKlO32Wjn22kRmaGF2KuY48r+Y+NUyZKCQmliyI
	I/Lvaq4FLYorwe1JvT185ZKxoa5kcjGTpmY9gDnu+KETSGmw7BrLkL4qIxkAwcDRZp/cLB7eMco
	Unv1W4gCskVvrJdnTp2Bjdwukmh9u0zbZwzjY128UG
X-Received: by 2002:a05:620a:178f:b0:8cf:c877:ed20 with SMTP id af79cd13be357-8d01c8439a5mr1742355485a.70.1774905984053;
        Mon, 30 Mar 2026 14:26:24 -0700 (PDT)
Received: from ArchTX.mobile.psu.edu ([104.39.41.64])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d02806a37bsm688341885a.34.2026.03.30.14.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 14:26:23 -0700 (PDT)
From: Dingisoul <dingiso.kernel@gmail.com>
To: dave.hansen@intel.com
Cc: bp@alien8.de,
	dave.hansen@linux.intel.com,
	dingiso.kernel@gmail.com,
	hpa@zytor.com,
	jarkko@kernel.org,
	linux-sgx@vger.kernel.org,
	mingo@redhat.com,
	shuangpeng.kernel@gmail.com,
	tglx@kernel.org,
	x86@kernel.org
Subject: Re: Re: [BUG] x86/sgx: missing kref_put() in sgx_encl_mm_add() error path
Date: Mon, 30 Mar 2026 17:25:55 -0400
Message-ID: <20260330212555.880843-1-dingiso.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <6d6fad13-762d-488e-a0b2-86704af64f33@intel.com>
References: <6d6fad13-762d-488e-a0b2-86704af64f33@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Dave,

Thanks for the confirmation and the suggestion. 

Moving the kref_get() after the successful mmu_notifier 
registration looks great and keeps the error path clean. 

Should we send a formal patch?
